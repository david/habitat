defmodule Habitat.Modules.Elixir do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("elixir")
  end
end
