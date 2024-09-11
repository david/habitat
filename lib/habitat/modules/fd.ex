defmodule Habitat.Modules.Fd do
  use Habitat.Module

  def pre_sync(container, _, _) do
    put_package(container, "fd", provider: Habitat.PackageManager.Brew)
  end
end
