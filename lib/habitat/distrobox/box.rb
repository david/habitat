require "fileutils"

module Habitat
  class Distrobox
    class Box
      attr_reader :name

      def initialize(id: nil, image: nil, name:)
        @id = id
        @name = name.to_sym

        debug @name

        @image = image
        @exports = {}
        @links = {}
        @volumes = {}
      end

      def home=(val)
        @home = val
      end

      def hash
        @name.hash
      end

      def image=(val)
        @image = val
      end

      def export(app, **opts)
        @exports[app] = opts
      end

      def link(from, to, **opts)
        @links[from] = [to, opts]
      end

      def packages=(val)
        @packages = val
      end

      def volume(from, to)
        @volumes[from] = to
      end

      def sync
        create if new?

        sync_packages
        sync_exports
        sync_links
      end

      def create
        raise "box '#{@name}' already exists" unless new?

        opts = [
          ["--home", @home],
          ["--image", @image],
          ["--name", @name],
          "--no-entry",
          "--yes"
        ]

        run "distrobox create #{opts.flatten.join(" ")} #{volumes.flatten.join(" ")}"
      end

      private def run(command)
        debug command

        output = %x{#{command}}

        if $? != 0
          warn "#{@name}: unable to run command\n\n#{output}"
        end

        output
      end

      private def sync_exports
        @exports.each do |k, opts|
          opts => {command:, label:}

          debug "on #{@name}"
          output = run("distrobox enter #{@name} -- cat /usr/share/applications/#{k}.desktop")

          desktop = output.lines.map { |line|
            if line =~ /^Exec=/
              "Exec=#{command}"
            elsif line =~ /^Name=/
              "Name=#{label}"
            else
              line.strip
            end
          }

          File.write(
            "#{ENV["HOME"]}/.local/share/applications/#{@name}-#{k}.desktop",
            desktop.join("\n") + "\n"
          )
        end
      end

      private def sync_links
        @links.each do |from, (to, opts)|
          to = File.expand_path(to.gsub(/^~/, @home))
          paths = Dir[from]

          if paths.length > 1
            FileUtils.mkdir_p(to)
          end

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

      private def sync_packages
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

        run "distrobox enter #{@name} -- sudo pacman #{opts.join(" ")} #{@packages.join(" ")}"
      end

      private def volumes
        volumes = @volumes.map { |host, box|
          host = File.expand_path(host.gsub(/^~/, ENV["HOME"]))
          box = File.expand_path(box.gsub(/^~/, @home))

          ["--volume", "#{host}:#{box}"]
        }
      end

      private def new?
        @id.nil?
      end

      private def debug(*args)
        puts(*args)
      end
    end
  end
end
