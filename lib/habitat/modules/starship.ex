defmodule Habitat.Modules.Starship do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    install(container_id, "starship")

    if config = Keyword.get(opts, :config) do
      insert(container_id, "~/.config/starship.toml", toml(config))
    end

    insert(container_id, "~/.bashrc", interactive: "eval \"$(starship init bash)\"")
    insert(container_id, "~/.zshrc", interactive: "eval \"$(starship init zsh)\"")
    insert(container_id, "~/.config/fish/config.fish", interactive: "starship init fish | source")
  end
end
