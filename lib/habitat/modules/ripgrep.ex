defmodule Habitat.Modules.Ripgrep do
  use Habitat.Module

  def pre_sync(container, _, _) do
    put_package(container, "ripgrep", provider: Habitat.PackageManager.Brew)
  end
end
