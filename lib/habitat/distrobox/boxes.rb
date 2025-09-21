module Habitat
  class Distrobox
    class Boxes
      def initialize
        @set = Set.new

        `distrobox list`.lines.drop(1).map { |line|
          id, name, status, image = line.split("|").map(&:strip)

          @set << Box.new(id:, image:, name:)
        }
      end

      def [](name)
        if box = @set.find { |box| box.name == name }
          box
        else
          box = Box.new(name:)

          @set << box

          box
        end
      end
    end
  end
end
