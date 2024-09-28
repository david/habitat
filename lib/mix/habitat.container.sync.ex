defmodule Mix.Tasks.Habitat.Container.Sync do
  @shortdoc "Update container configuration"

  require Logger

  use Mix.Task

  alias Habitat.{Container, Manifest}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    {:ok, blueprint} = Habitat.Blueprint.load()

    for arg <- args, id = String.to_atom(arg) do
      if container_blueprint = Enum.find(blueprint.containers, &(&1.id == id)) do
        container_blueprint
        |> Manifest.new()
        |> Manifest.sync(Map.take(container_blueprint, [:id, :root]))
      else
        Logger.warn("Container `#{id}' not found")
      end
    end
  end
end
