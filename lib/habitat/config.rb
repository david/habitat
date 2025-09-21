module Habitat
  class Config
    def initialize(host:, active_template_names:, available_templates:, &config)
      @host = host

      @exports = {}
      @links = {}
      @locales = []
      @packages = []
      @repos = {}
      @volumes = {}

      Array(active_template_names).each do |t|
        raise "missing template '#{t}'" unless available_templates[t]

        available_templates[t].call self
      end

      config.call self
    end

    def export(name, **opts)
      @exports[name] = opts
    end

    def home(val)
      @home = val
    end

    def image(val)
      @image = val
    end

    def link(from, to, **opts)
      @links[from] = [to, opts]
    end

    def locale(*locales)
      @locales = locales
    end

    def packages(*packages)
      @packages = packages
    end

    def repo(repo, **opts)
      @repos[repo] = opts
    end

    def volume(from, to)
      @volumes[from] = to
    end

    def sync
      @host.sync(
        exports: @exports,
        home: @home,
        image: @image,
        links: @links,
        locales: @locales,
        packages: @packages,
        repos: @repos,
        volumes: @volumes.map do |from, to|
          [
            expand_path(from, "~" => ENV["HOME"]),
            expand_path(to, "~" => @home)
          ]
        end
      )
    end

    private def expand_path(path, substitutions)
      substitutions.each do |abbrev, expanded|
        path = path.gsub(abbrev, expanded)
      end

      File.expand_path(path)
    end
  end
end
