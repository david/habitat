defmodule Habitat.Modules.Lsd do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    install(container_id, "lsd")

    if config = Keyword.get(opts, :config) do
      insert(container_id, "~/.config/lsd/config.yml", yaml(config))
    end

    case Keyword.get(opts, :alias) do
      :default ->
        aliases = """
        alias ls=lsd
        alias ll="lsd -l"
        alias la="lsd -a"
        alias lla="lsd -la"
        """

        insert(container_id, "~/.bashrc", interactive: aliases)
        insert(container_id, "~/.zshrc", interactive: aliases)
        insert(container_id, "~/.config/fish/config.fish", interactive: aliases)

      nil ->
        nil
    end
  end
end
