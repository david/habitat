module Habitat
  module Shell
    class Distrobox
      def initialize(name, runner)
        @name = name
        @runner = runner
      end

      def run(command, **opts)
        system("distrobox", "enter", @name, "--", *@runner.run(command, **opts))
      end

      def read(path)
        `#{["distrobox", "enter", @name, "--", "cat", path].join(" ")}`
      end

      def write(path, content, sudo: false)
        tmp_path = nil

        Tempfile.open do |file|
          tmp_path = file.path

          file.write(content)
        end

        run(["cp", tmp_path, path], sudo:)
      end
    end
  end
end
