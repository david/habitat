module Habitat
  module OS
    class ArchLinux
      def initialize(shell)
        @shell = shell

        @locales = Locales.new(shell)
        @packages = Pacman.new(shell)
      end

      def sync(spec)
        @locales.sync(spec)
        @packages.sync(spec)
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
