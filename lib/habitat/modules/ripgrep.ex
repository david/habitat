defmodule Habitat.Modules.Ripgrep do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "ripgrep", provider: Habitat.PackageManager.Brew)
  end
end
