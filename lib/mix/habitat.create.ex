defmodule Mix.Tasks.Habitat.Create do
  @shortdoc "Create missing containers"

  use Mix.Task

  alias Habitat.Distrobox

  @requirements ["app.start"]

  @images %{
    ubuntu: "ghcr.io/david/habitat-ubuntu:latest"
  }

  @impl true
  def run(names) do
    ids = Enum.map(names, &String.to_atom/1)

    {:ok, blueprints} = Habitat.Blueprint.load()

    for %{id: id, os: os, root: root} <- blueprints, id in ids do
      Distrobox.create(to_string(id), @images[os], root)
    end
  end
end
