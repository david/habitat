defmodule Mix.Tasks.Habitat.Delete do
  @shortdoc "Delete one or more containers"

  use Mix.Task

  alias Habitat.{Blueprint, Distrobox}

  @requirements ["app.start"]

  @impl true
  def run(names) do
    ids = Enum.map(names, &String.to_atom/1)

    {:ok, blueprints} = Habitat.Blueprint.load()

    for %{id: id} <- blueprints, id in ids do
      Distrobox.stop(to_string(id))
      Distrobox.delete(to_string(id))
    end
  end
end
