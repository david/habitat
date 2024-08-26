defmodule Habitat.Modules.Git do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "git")
  end
end
