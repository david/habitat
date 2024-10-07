defmodule Mix.Tasks.Habitat.Container.Sync do
  @shortdoc "Update container configuration"

  require Logger

  use Mix.Task

  alias Habitat.{Blueprint, Manifest}

  @requirements ["app.start"]

  @impl true
  def run(_) do
    {:ok, blueprint} = Blueprint.load()

    id = String.to_atom(System.get_env("CONTAINER_ID"))

    with {:ok, cb} <- Blueprint.get_container_blueprint(blueprint, id),
         {:ok, cm} <- Blueprint.get_container_manifest(blueprint, id) do
      Manifest.sync(cm, cb)
    else
      {:error, :container_not_found} -> Logger.warning("Container `#{id}' not found")
    end
  end
end
