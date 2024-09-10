defmodule Habitat.Modules.Fzf do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "fzf", provider: Habitat.PackageManager.Brew)
  end
end
