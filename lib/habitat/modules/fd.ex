defmodule Habitat.Modules.Fd do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "fd", provider: Habitat.PackageManager.Brew)
  end
end
