require "tempfile"

module Habitat
  module Shell
    class Runner
      def run(command, sudo: false)
        [sudo ? "sudo" : nil, *command].compact
      end

      def read(path)
        ["cat", path]
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
