defmodule Habitat.Modules.Lsd do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    install(container_id, "lsd")

    if config = Keyword.get(opts, :config) do
      put_string(container_id, "~/.config/lsd/config.yml", yaml(config))
    end

    case Keyword.get(opts, :alias) do
      :default ->
        aliases = """
        alias ls=lsd
        alias ll="lsd -l"
        alias la="lsd -a"
        alias lla="lsd -la"
        """

        append(container_id, "~/.bashrc", aliases)
        append(container_id, "~/.zshrc", aliases)
        append(container_id, "~/.config/fish/config.fish", aliases)

      nil ->
        nil
    end
  end
end
