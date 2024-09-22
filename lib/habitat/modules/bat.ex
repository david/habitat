defmodule Habitat.Modules.Bat do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("bat")
  end
end
