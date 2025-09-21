require "optparse"

module Habitat
  module CLI
    autoload :Sync, "habitat/cli/sync"

    def self.call(argv)
      options = {}

      parser = OptionParser.new

      command, = parser.parse(argv)

      case command
      when "sync"
        Habitat::CLI::Sync.call
      end
    end
  end
end
