defmodule Habitat.Programs.Atuin do
  alias Habitat.{Files, Packages, Shells}

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring atuin")

    container
    |> Files.put_dir("~/data/atuin")
    |> Files.put_symlink("~/data/atuin", "~/.local/share/atuin")
    |> Shells.put(:bash, "atuin", "eval \"$(atuin init bash)\"")
    |> Shells.put(:zsh, "atuin", "eval \"$(atuin init zsh)\"")
    |> Packages.put("atuin")
  end
end
