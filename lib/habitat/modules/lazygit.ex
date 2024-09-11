defmodule Habitat.Modules.Lazygit do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "lazygit", provider: Habitat.PackageManager.Brew)
  end
end
