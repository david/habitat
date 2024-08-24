defmodule Habitat.Programs.Starship do
  require Logger
  alias Habitat.Tasks.{Packages, Shells}

  def pre_sync(container, _) do
    Logger.info("Configuring starship")

    container
    |> Packages.put("starship")
    |> Shells.put(:bash, "starship", "eval \"$(starship init bash)\"")
    |> Shells.put(:zsh, "starship", "eval \"$(starship init zsh)\"")
  end
end
