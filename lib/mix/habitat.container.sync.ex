defmodule Mix.Tasks.Habitat.Container.Sync do
  @shortdoc "Update container configuration"

  require Logger

  use Mix.Task

  alias Habitat.{Blueprint, Container, Manifest}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    {:ok, blueprint} = Habitat.Blueprint.load()

    for arg <- args, id = String.to_atom(arg) do
      if container_blueprint = Enum.find(blueprint.containers, &(&1.id == id)) do
        Manifest.sync(
          Blueprint.get_container_manifest(blueprint, id),
          container_blueprint
        )
      else
        Logger.warn("Container `#{id}' not found")
      end
    end
  end
end
