defmodule Mix.Tasks.Habitat.Delete do
  @shortdoc "Delete one or more containers"

  use Mix.Task

  alias Habitat.{Blueprint, Distrobox}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    for arg <- args, id = String.to_atom(arg) do
      {:ok, _} = Blueprint.get_container(id)

      Distrobox.stop(arg)
      Distrobox.delete(arg)
    end
  end
end
