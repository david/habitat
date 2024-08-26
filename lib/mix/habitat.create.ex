defmodule Mix.Tasks.Habitat.Create do
  @shortdoc "Create missing containers"

  use Mix.Task

  @requirements ["app.start"]

  @impl true
  def run(args) do
    for arg <- args, id = String.to_atom(arg) do
      {:ok, _} = Habitat.Blueprint.get_container(id)

      Habitat.Container.create(id)
    end
  end
end
