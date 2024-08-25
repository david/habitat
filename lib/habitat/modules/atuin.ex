defmodule Habitat.Modules.Atuin do
  use Habitat.Module
  alias Habitat.Shells

  def pre_sync(container, _) do
    install(container, "atuin")

    container
    |> Shells.put(:bash, "atuin", "eval \"$(atuin init bash)\"")
    |> Shells.put(:zsh, "atuin", "eval \"$(atuin init zsh)\"")
  end
end
