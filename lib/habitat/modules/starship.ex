defmodule Habitat.Modules.Starship do
  use Habitat.Module

  alias Habitat.Shells

  def pre_sync(container_id, opts, _) do
    install(container_id, "starship")

    if config = Keyword.get(opts, :config) do
      put_string(container_id, "~/.config/starship.toml", toml(config))
    end

    append(container_id, "~/.bashrc", "eval \"$(starship init bash)\"")
    append(container_id, "~/.zshrc", "eval \"$(starship init zsh)\"")
  end
end
