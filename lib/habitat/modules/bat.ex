defmodule Habitat.Modules.Bat do
  use Habitat.Module

  def pre_sync(container, _, _) do
    put_package(container, "bat", provider: Habitat.PackageManager.Brew)
  end
end
