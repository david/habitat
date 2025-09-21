module Habitat
  class Config
    def initialize(host:, active_template_names:, available_templates:, &config)
      @host = host

      Array(active_template_names).each do |t|
        raise "missing template '#{t}'" unless available_templates[t]

        available_templates[t].call self
      end

      config.call self
    end

    def export(name, **opts)
      @host.export(name, **opts)
    end

    def home(val)
      @host.home = val
    end

    def image(val)
      @host.image = val
    end

    def link(from, to, **opts)
      @host.link(from, to, **opts)
    end

    def locale(*locales)
      @host.locale(*locales)
    end

    def packages(*pkgs)
      @host.packages = pkgs
    end

    def repo(repo, **opts)
      @host.repo(repo, **opts)
    end

    def volume(from, to)
      @host.volume(from, to)
    end

    def sync
      @host.sync
    end
  end
end
