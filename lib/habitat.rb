# frozen_string_literal: true

require_relative "habitat/version"

module Habitat
  autoload :CLI, "habitat/cli"
  autoload :Config, "habitat/config"
  autoload :Distrobox, "habitat/distrobox"
  autoload :History, "habitat/history"
  autoload :OS, "habitat/os"
  autoload :Shell, "habitat/shell"
  autoload :Spec, "habitat/spec"

  class Error < StandardError; end
end
