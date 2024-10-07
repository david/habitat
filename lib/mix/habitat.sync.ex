defmodule Mix.Tasks.Habitat.Sync do
  @shortdoc "Update container configuration"

  require Logger

  use Mix.Task

  alias Habitat.{Blueprint, Manifest}

  @requirements ["app.start"]

  @impl true
  def run(_) do
    {:ok, blueprint} = Blueprint.load()
    {:ok, manifest} = Blueprint.to_manifest(blueprint)

    Manifest.sync(manifest, blueprint)
  end
end
