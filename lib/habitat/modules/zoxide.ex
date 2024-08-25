defmodule Habitat.Modules.Zoxide do
  use Habitat.Module

  alias Habitat.Shells

  def pre_sync(container, _) do
    install(container, "zoxide")

    container
    |> Shells.put(:bash, "zoxide", "eval \"$(zoxide init bash)\"")
    |> Shells.put(:zsh, "zoxide", "eval \"$(zoxide init zsh)\"")
  end
end
