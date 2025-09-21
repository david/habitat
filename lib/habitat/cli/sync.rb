module Habitat
  module CLI
    class Sync
      def self.call
        new.instance_eval(File.read("Habitatfile"))
      end

      def initialize
        @distrobox = Distrobox.new
        @templates = {}
      end

      def box(name, template: [], &)
        @distrobox.
          boxes[name].
          tap { |b| Array(template).each { |t| @templates[t].call(b) } }.
          tap(&).
          sync
      end

      def template(name, &block)
        @templates[name] = block
      end
    end
  end
end
