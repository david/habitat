defmodule Habitat.Modules.Git do
  use Habitat.Module

  def pre_sync(container, _, _) do
    put_package(container, "git")
  end
end
