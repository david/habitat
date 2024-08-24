defmodule Habitat.Programs.Zoxide do
  alias Habitat.{Packages, Shells}

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring zoxide")

    container
    |> Shells.put(:bash, "zoxide", "eval \"$(zoxide init bash)\"")
    |> Shells.put(:zsh, "zoxide", "eval \"$(zoxide init zsh)\"")
    |> Packages.put("zoxide")
  end
end
