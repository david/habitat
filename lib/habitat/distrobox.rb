module Habitat
  class Distrobox
    autoload :Box, "habitat/distrobox/box"
    autoload :Boxes, "habitat/distrobox/boxes"

    def boxes
      @boxes ||= Boxes.new
    end
  end
end
