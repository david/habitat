defmodule Mix.Tasks.Habitat do
  @shortdoc "Update system configuration"
  use Mix.Task

  alias Habitat.Container

  @impl Mix.Task
  def run(_) do
    units = Code.require_file("lib/blueprints.ex")

    {mod, _} = List.first(units)

    for c <- mod.containers() do
      Container.configure(c)
    end
  end
end
