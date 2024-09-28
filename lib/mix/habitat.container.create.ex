defmodule Mix.Tasks.Habitat.Container.Create do
  @shortdoc "Create missing containers"

  use Mix.Task

  alias Habitat.Distrobox

  @requirements ["app.start"]

  @impl true
  def run(names) do
    ids = Enum.map(names, &String.to_atom/1)

    {:ok, blueprint} = Habitat.Blueprint.load()

    for %{id: id, image: image, root: root} <- blueprint.containers, id in ids do
      Distrobox.create(to_string(id), image, root)
    end
  end
end
