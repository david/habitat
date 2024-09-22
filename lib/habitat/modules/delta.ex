defmodule Habitat.Modules.Delta do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("git-delta")
  end
end
