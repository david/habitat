require "yaml"

module Habitat
  class Spec
    autoload :Builder, "habitat/spec/builder"

    def initialize(name:, **state)
      @name = name.to_s
      @state = state
    end

    Link = Data.define(:source, :destination)

    Locale = Data.define(:name) {
      alias_method :to_s, :name
    }

    Package = Data.define(:name, :source, :to) {
      def initialize(**opts)
        super(to: nil, **opts)
      end

      alias_method :to_s, :name
    }

    Source = Data.define(:key, :keyserver, :mirrorlist, :name, :packages)

    def links
      @links ||= @state[:links].flat_map { |link| Link.new(**link) }
    end

    def locales
      @locales ||= @state[:locales].map { |locale| Locale.new(**locale) }
    end

    def packages
      @packages ||= @state[:packages].map { |pkg| Package.new(**pkg) }
    end

    def sources
      @sources ||= @state[:sources].map { |src| Source.new(**src) }
    end

    def write(path)
      @path = path

      File.write(path, YAML.dump(@state))
    end

    attr_reader :name, :state
    protected :state
  end
end
