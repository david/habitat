defmodule Habitat.Modules.Starship do
  use Habitat.Module

  alias Habitat.Shells

  def pre_sync(container, _) do
    install(container, "starship")

    container
    |> Shells.put(:bash, "starship", "eval \"$(starship init bash)\"")
    |> Shells.put(:zsh, "starship", "eval \"$(starship init zsh)\"")
  end
end
