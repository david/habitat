defmodule Habitat.Modules.Lazygit do
  use Habitat.Module

  def pre_sync(container, _, _) do
    put_package(container, "lazygit", provider: Habitat.PackageManager.Brew)
  end
end
