defmodule Habitat.Modules.Starship do
  use Habitat.Module

  alias Habitat.{Shells}

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring starship")

    install(container, "starship")

    container
    |> Shells.put(:bash, "starship", "eval \"$(starship init bash)\"")
    |> Shells.put(:zsh, "starship", "eval \"$(starship init zsh)\"")
  end
end
