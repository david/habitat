defmodule Habitat.Modules.Zoxide do
  use Habitat.Module

  alias Habitat.Shells

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring zoxide")

    install(container, "zoxide")

    container
    |> Shells.put(:bash, "zoxide", "eval \"$(zoxide init bash)\"")
    |> Shells.put(:zsh, "zoxide", "eval \"$(zoxide init zsh)\"")
  end
end
