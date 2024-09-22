defmodule Mix.Tasks.Habitat.Sync do
  @shortdoc "Update system configuration"
  use Mix.Task

  alias Habitat.{Container, Manifest}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    {:ok, blueprints} = Habitat.Blueprint.load()

    for arg <- args, id = String.to_atom(arg) do
      blueprints
      |> Enum.find(&(&1.id == id))
      |> Manifest.new()
      |> Container.sync()
    end
  end
end
