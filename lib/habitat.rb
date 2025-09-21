# frozen_string_literal: true

require_relative "habitat/version"

module Habitat
  autoload :CLI, "habitat/cli"
  autoload :Config, "habitat/config"
  autoload :Distrobox, "habitat/distrobox"

  class Error < StandardError; end
end
