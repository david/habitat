defmodule Habitat.Modules.WlClipboard do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package({:apt, "wl-clipboard"})
  end
end
