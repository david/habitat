module Habitat
  class Spec
    class Builder
      def self.load(path)
        builder = new

        builder.instance_eval(File.read(path))

        builder
      end

      def initialize
        @specs = {}
        @templates = {}
      end

      def box(name, template: [], &config)
        raise "box #{name} already exists" if @specs[name]

        spec = @specs[name] = Spec.new(name)

        Array(template).each { |t| @templates[t].call(spec) }
        config.call(spec)
      end

      def template(name, &config)
        @templates[name] = config
      end

      def specs
        @specs.values.map { |spec| Habitat::Spec.new(**spec.to_state) }
      end

      class Spec
        def initialize(name)
          @name = name

          @exports = []
          @links = []
          @locales = []
          @packages = []
          @sources = []
          @volumes = []
        end

        def export(name, **opts)
          @exports << { name:, **opts }
        end

        def home(val)
          @home = val
        end

        def image(val)
          @image = val
        end

        def link(from, to)
          @links << { from:, to: }
        end

        def locale(*locales)
          @locales.concat(locales.map { |name| { name: } })
        end

        def package(*packages, **opts)
          @packages.concat(packages.map { |name| { name:, **opts } })
        end

        def source(name, **opts)
          @sources << { name:, **opts }
        end

        def volume(from, to)
          @volumes << { from:, to: }
        end

        def to_state
          {
            name: @name,
            locales: @locales,
            packages: @packages.map { |pkg| { source: :pacman, **pkg } },
            sources: @sources
          }
        end
      end
    end
  end
end
