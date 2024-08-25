defmodule Habitat.Programs.Zoxide do
  alias Habitat.{Packages, Shells}

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring zoxide")

    container
    |> Files.put_dir("~/data/zoxide")
    |> Files.put_symlink("~/data/zoxide", "~/.local/share/zoxide")
    |> Shells.put(:bash, "zoxide", "eval \"$(zoxide init bash)\"")
    |> Shells.put(:zsh, "zoxide", "eval \"$(zoxide init zsh)\"")
    |> Packages.put("zoxide")
  end
end
