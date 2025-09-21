require "fileutils"
require "tempfile"

module Habitat
  class Distrobox
    class Box
      attr_reader :name

      def initialize(name:, id: nil, image: nil)
        @id = id
        @name = name.to_sym
        @image = image
      end

      def hash
        @name.hash
      end

      def sync(exports:, home:, image:, links:, locales:, packages:, repos:, volumes:)
        create(home:, image:, volumes:) if new?

        sync_repos(repos)
        sync_locales(locales)
        sync_packages(packages)
        sync_exports(exports)
        sync_links(links, home)
      end

      def create(home:, image:, volumes:)
        raise "box '#{@name}' already exists" unless new?

        opts = [
          ["--home", home],
          ["--image", image],
          ["--name", @name],
          "--no-entry",
          "--yes"
        ] + volumes.map { |from, to| ["--volume", "#{from}:#{to}"] }

        run "distrobox create #{opts.flatten.join(" ")} #{volumes.flatten.join(" ")}"
      end

      private def run(command)
        debug command

        output = `#{command}`

        warn "#{@name}: unable to run command\n\n#{output}" if $? != 0

        output
      end

      private def sync_repos(repos)
        repos.each do |name, opts|
          switches = [
            ["--recv-key", opts[:key]],
            ["--keyserver", opts[:keyserver]]
          ]

          run("distrobox enter #{@name} -- sudo pacman-key #{switches.flatten.join(" ")}")

          switches = [
            ["--lsign-key", opts[:key]]
          ]

          run("distrobox enter #{@name} -- sudo pacman-key #{switches.flatten.join(" ")}")

          switches = [
            "--needed",
            "--noconfirm",
            "--upgrade"
          ]

          packages = opts[:packages]
          command = "distrobox enter #{@name} -- " \
            "sudo pacman #{switches.flatten.join(" ")} #{packages.join(" ")}"

          run(command)

          pacman_conf = read("/etc/pacman.conf")

          repo_alias = opts[:as] || name

          next unless pacman_conf !~ /\[#{repo_alias}\]/

          write(
            "/etc/pacman.conf",
            "#{pacman_conf}\n\n[#{repo_alias}]\nInclude = /etc/pacman.d/#{name}-mirrorlist\n",
            sudo: true
          )
        end
      end

      private def sync_locales(locales)
        locale_gen = locales.map { |l| "#{l} UTF-8" }.join("\n") + "\n"

        write "/etc/locale.gen", locale_gen, sudo: true
        write "/etc/locale.conf", "LANG=#{locales.first}\n", sudo: true

        run "distrobox enter #{@name} -- sudo locale-gen"
      end

      private def sync_exports(exports)
        exports.each do |k, opts|
          opts => { command:, label: }

          debug "on #{@name}"
          output = read("/usr/share/applications/#{k}.desktop")

          desktop = output.lines.map do |line|
            if line =~ /^Exec=/
              "Exec=distrobox enter --no-workdir #{@name} -- #{command}"
            elsif line =~ /^Name=/
              "Name=#{label}"
            else
              line.strip
            end
          end

          File.write(
            "#{ENV["HOME"]}/.local/share/applications/#{@name}-#{k}.desktop",
            desktop.join("\n") + "\n"
          )
        end

        system "update-desktop-database"
      end

      private def sync_links(links, home)
        links.each do |from, (to, opts)|
          to = File.expand_path(to.gsub(/^~/, home))
          paths = Dir[from]

          FileUtils.mkdir_p(to) if paths.length > 1

          Dir[from].each do |path|
            filename =
              if opts[:transform]
                opts[:transform].call(File.basename(path))
              else
                File.basename(path)
              end

            debug "Linking #{path} => #{to}/#{filename}"

            FileUtils.ln_sf(File.expand_path(path), "#{to}/#{filename}")
          end
        end
      end

      private def sync_packages(packages)
        opts = [
          "--noconfirm",
          "--refresh",
          "--sync",
          "--sysupgrade"
        ]

        run "distrobox enter #{@name} -- sudo pacman #{opts.join(" ")}"

        opts = [
          "--needed",
          "--noconfirm",
          "--sync"
        ]

        run "distrobox enter #{@name} -- sudo pacman #{opts.join(" ")} #{packages.join(" ")}"
      end

      private def new?
        @id.nil?
      end

      private def debug(*args)
        puts(*args)
      end

      private def read(path)
        run("distrobox enter #{@name} -- cat #{path}")
      end

      private def write(path, content, sudo: false)
        host_path = nil

        Tempfile.open do |file|
          host_path = "/run/host#{file.path}"

          file.write(content)
        end

        run "distrobox enter #{@name} -- #{sudo ? "sudo" : ""} cp #{host_path} #{path}"
      end
    end
  end
end
