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
      with {:ok, container_blueprint} <- Blueprint.get_container_blueprint(blueprint, id),
           {:ok, container_manifest} <- Blueprint.get_container_manifest(blueprint, id) do
        Manifest.sync(container_manifest, container_blueprint)
      else
        {:error, :container_not_found} -> Logger.warning("Container `#{id}' not found")
      end
    end
  end
end
