defmodule Habitat.Modules.Lazygit do
  use Habitat.Module

  alias Habitat.PackageManager.Brew

  def pre_sync(container, _, _) do
    install(container, "lazygit", provider: Brew)
  end
end
