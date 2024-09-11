defmodule Habitat.Modules.Fzf do
  use Habitat.Module

  def pre_sync(container, _, _) do
    put_package(container, "fzf", provider: Habitat.PackageManager.Brew)
  end
end
