defmodule Habitat.Modules.Lsd do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    put_package(container_id, "lsd", provider: Habitat.PackageManager.Brew)

    if config = Keyword.get(opts, :config) do
      put_file(container_id, "~/.config/lsd/config.yml", yaml(config))
    end

    case Keyword.get(opts, :alias) do
      :default ->
        aliases = """
        alias ls=lsd
        alias ll="lsd -l"
        alias la="lsd -a"
        alias lla="lsd -la"
        """

        put_file(container_id, "~/.bashrc", interactive: aliases)
        put_file(container_id, "~/.zshrc", interactive: aliases)
        put_file(container_id, "~/.config/fish/config.fish", interactive: aliases)

      nil ->
        nil
    end
  end
end
