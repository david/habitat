defmodule Habitat.Modules.Gh do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("gh")
  end
end
