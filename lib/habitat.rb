# frozen_string_literal: true

require_relative "habitat/version"

module Habitat
  autoload :CLI, "habitat/cli"
  autoload :OS, "habitat/os"
  autoload :Shell, "habitat/shell"
  autoload :Spec, "habitat/spec"

  class Error < StandardError; end
end
