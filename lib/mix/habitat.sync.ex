defmodule Mix.Tasks.Habitat.Sync do
  @shortdoc "Update system configuration"

  use Mix.Task

  alias Habitat.{Container, Manifest}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    {:ok, blueprints} = Habitat.Blueprint.load()

    for arg <- args, id = String.to_atom(arg) do
      blueprint = Enum.find(blueprints, &(&1.id == id))

      blueprint
      |> Manifest.new()
      |> Manifest.sync(Map.take(blueprint, [:id, :root]))
    end
  end
end
