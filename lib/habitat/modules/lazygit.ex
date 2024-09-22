defmodule Habitat.Modules.Lazygit do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("lazygit")
  end
end
