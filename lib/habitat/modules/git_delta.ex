defmodule Habitat.Modules.GitDelta do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "git-delta", provider: Habitat.PackageManager.Brew)
  end
end
