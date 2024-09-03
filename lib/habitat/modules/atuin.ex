defmodule Habitat.Modules.Atuin do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    install(container_id, "atuin")

    if config = Keyword.get(opts, :config) do
      insert(container_id, "~/.config/atuin/config.toml", toml(config))
    end

    insert(container_id, "~/.bashrc", interactive: "eval \"$(atuin init bash)\"")
    insert(container_id, "~/.zshrc", interactive: "eval \"$(atuin init zsh)\"")
    insert(container_id, "~/.config/fish/config.fish", interactive: "atuin init fish | source")
  end
end
