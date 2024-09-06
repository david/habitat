defmodule Mix.Tasks.Habitat.Sync do
  @shortdoc "Update system configuration"
  use Mix.Task

  alias Habitat.{Container, Modules, OS}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    for arg <- args, id = String.to_atom(arg) do
      {:ok, blueprint} = Habitat.Blueprint.get_container(id)

      os = Keyword.get(blueprint, :os)

      OS.get(os).pre_sync(id, blueprint)
      Modules.pre_sync(id, blueprint)
      Container.sync(id)
    end
  end
end
