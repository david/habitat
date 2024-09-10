defmodule Habitat.Modules.Bat do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "bat", provider: Habitat.PackageManager.Brew)
  end
end
