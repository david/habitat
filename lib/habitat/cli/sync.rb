module Habitat
  module CLI
    class Sync
      def self.call
        new.instance_eval(File.read("Habitatfile"))
      end

      def initialize
        @distrobox = Distrobox.new
      end

      def box(name, &)
        @distrobox.
          boxes[name].
          tap(&).
          sync
      end
    end
  end
end
