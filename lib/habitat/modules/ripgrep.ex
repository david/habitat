defmodule Habitat.Modules.Ripgrep do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("ripgrep")
  end
end
