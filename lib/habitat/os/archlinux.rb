module Habitat
  module OS
    class ArchLinux
      def initialize(shell)
        @shell = shell

        @links = Links.new(shell)
        @locales = Locales.new(shell)
        @packages = Pacman.new(shell)
        @sources = Sources.new(shell)
      end

      def sync(spec)
        @locales.sync(spec)
        @sources.sync(spec)
        @packages.sync(spec)
        @links.sync(spec)
      end

      class Links
        def initialize(shell)
          @shell = shell
        end

        def sync(spec)
          spec.links.each do |link|
            destination =
              if File.directory?(link.destination)
                File.join(link.destination, File.basename(link.source))
              else
                link.destination
              end

            FileUtils.mkdir_p File.dirname(destination)

            if !File.exist?(destination)
              FileUtils.ln_s(link.source, destination)
            elsif File.symlink?(destination)
              next
            else
              warn "Skipping #{destination}: file exists"
            end
          end
        end
      end

      class Sources
        def initialize(shell)
          @shell = shell
        end

        def sync(spec)
          spec.sources.each do |source|
            switches = [
              ["--recv-key", source.key],
              ["--keyserver", source.keyserver]
            ]

            @shell.run(["pacman-key", *switches.flatten], sudo: true)
            @shell.run(["pacman-key", "--lsign-key", source.key], sudo: true)

            switches = [
              "--needed",
              "--noconfirm",
              "--upgrade"
            ]

            @shell.run(["pacman", *switches.flatten, *source.packages], sudo: true)

            pacman_conf = @shell.read("/etc/pacman.conf")

            next unless pacman_conf !~ /\[#{source.name}\]/

            write(
              "/etc/pacman.conf",
              "#{pacman_conf}\n\n[#{source.name}]\nInclude = /etc/pacman.d/#{source.mirrorlist}\n",
              sudo: true
            )
          end
        end
      end

      class Locales
        def initialize(shell)
          @shell = shell
        end

        def sync(spec)
          @shell.write "/etc/locale.gen", locale_gen(spec.locales), sudo: true
          @shell.write "/etc/locale.conf", locale_conf(spec.locales), sudo: true

          @shell.run "locale-gen", sudo: true
        end

        private def locale_gen(locales)
          locales.map { |l| "#{l} UTF-8" }.join("\n") + "\n"
        end

        private def locale_conf(locales)
          "LANG=#{locales.first}\n"
        end
      end

      class Pacman
        def initialize(shell)
          @shell = shell
        end

        def sync(spec)
          pkgs = spec.packages.filter { |pkg| pkg.source == :pacman }

          @shell.run(
            [
              "pacman",
              "--sync",
              "--refresh",
              "--needed",
              "--noconfirm",
              *pkgs.map(&:to_s)
            ],
            sudo: true
          )
        end
      end
    end
  end
end
