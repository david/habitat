defmodule Habitat.Modules.Fd do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("fd")
  end
end
