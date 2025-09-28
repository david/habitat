require "yaml"

module Habitat
  class Spec
    autoload :Builder, "habitat/spec/builder"

    def initialize(name:, **state)
      @name = name
      @state = state
    end

    Locale = Data.define(:name) do
      alias_method :to_s, :name
    end

    Package = Data.define(:name, :source, :to) do
      def initialize(**opts)
        super(to: nil, **opts)
      end

      alias_method :to_s, :name
    end

    Source = Data.define(:key, :keyserver, :mirrorlist, :name, :packages)

    def locales
      @state[:locales].map { |locale| Locale.new(**locale) }
    end

    def packages
      @state[:packages].map { |pkg| Package.new(**pkg) }
    end

    def sources
      @state[:sources].map { |src| Source.new(**src) }
    end

    def write(path)
      @path = path

      File.write(path, YAML.dump(@state))
    end

    attr_reader :name, :state
    protected :state
  end
end
