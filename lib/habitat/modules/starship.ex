defmodule Habitat.Modules.Starship do
  alias Habitat.{Packages, Shells}

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring starship")

    container
    |> Packages.put("starship")
    |> Shells.put(:bash, "starship", "eval \"$(starship init bash)\"")
    |> Shells.put(:zsh, "starship", "eval \"$(starship init zsh)\"")
  end
end
