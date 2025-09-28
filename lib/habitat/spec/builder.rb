module Habitat
  class Spec
    class Builder
      def self.load(path)
        pwd = File.dirname(File.expand_path(path))

        new(pwd).tap { |builder| builder.instance_eval(File.read(path)) }
      end

      def initialize(pwd)
        @pwd = pwd
        @specs = {}
        @templates = {}
      end

      def box(name, template: [], &config)
        raise "box #{name} already exists" if @specs[name]

        spec = @specs[name] = Spec.new(name, @pwd)

        Array(template).each do |t| @templates[t].call(spec) end
        config.call(spec)
      end

      def template(name, &config)
        @templates[name] = config
      end

      def specs
        @specs.values.map { |spec| Habitat::Spec.new(**spec.to_state) }
      end

      class Spec
        def initialize(name, pwd)
          @name = name
          @pwd = pwd

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
            links: @links.flat_map { |link| expand_link(link) },
            locales: @locales,
            packages: @packages.map { |pkg| { source: :pacman, **pkg } },
            sources: @sources
          }
        end

        private def expand_link(link)
          xfrom = File.expand_path(link[:from], @pwd)

          Dir[xfrom].map { |from|
            to = link[:to].respond_to?(:call) ? link[:to].call(from) : link[:to]
            to = File.expand_path(to, @pwd)

            { from:, to: }
          }
        end
      end
    end
  end
end
