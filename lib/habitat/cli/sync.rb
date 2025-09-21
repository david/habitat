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
        Config.new(
          host: @distrobox.boxes[name],
          active_template_names: template,
          available_templates: @templates,
          &
        ).sync
      end

      def template(name, &block)
        @templates[name] = block
      end
    end
  end
end
