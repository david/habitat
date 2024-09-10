defmodule Mix.Tasks.Habitat.Sync do
  @shortdoc "Update system configuration"
  use Mix.Task

  alias Habitat.{Container, Modules, OS}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    for arg <- args, id = String.to_atom(arg) do
      {:ok, %{os: os} = container} = Habitat.Blueprint.get_container(id)

      os.pre_sync(id, container)
      Modules.pre_sync(id, container)
      Container.sync(id)
    end
  end
end
