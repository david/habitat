defmodule Habitat.Modules.Zoxide do
  use Habitat.Module

  alias Habitat.Shells

  def pre_sync(container_id, _, _) do
    install(container_id, "zoxide")

    append(container_id, "~/.bashrc", "eval \"$(zoxide init bash)\"")
    append(container_id, "~/.zshrc", "eval \"$(zoxide init zsh)\"")

    append(
      container_id,
      "~/.config/fish/config.fish",
      "if status is-interactive; zoxide init fish | source; end"
    )
  end
end
