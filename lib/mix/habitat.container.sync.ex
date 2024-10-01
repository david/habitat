defmodule Mix.Tasks.Habitat.Container.Sync do
  @shortdoc "Update container configuration"

  require Logger

  use Mix.Task

  alias Habitat.{Blueprint, Manifest}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    {:ok, blueprint} = Blueprint.load()

    for arg <- args, id = String.to_atom(arg) do
      if container_blueprint = Blueprint.get_container_blueprint(blueprint, id) do
        Manifest.sync(
          Blueprint.get_container_manifest(blueprint, id),
          container_blueprint
        )
      else
        Logger.warning("Container `#{id}' not found")
      end
    end
  end
end
