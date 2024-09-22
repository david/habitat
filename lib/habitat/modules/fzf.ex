defmodule Habitat.Modules.Fzf do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("fzf")
  end
end
