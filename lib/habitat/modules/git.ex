defmodule Habitat.Modules.Git do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("git")
  end
end
