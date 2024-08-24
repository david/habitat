defmodule Habitat.Programs.Atuin do
  alias Habitat.Tasks.{Packages, Shells}
  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring atuin")

    container
    |> Shells.put(:bash, "atuin", "eval \"$(atuin init bash)\"")
    |> Shells.put(:zsh, "atuin", "eval \"$(atuin init zsh)\"")
    |> Packages.put("atuin")
  end
end
