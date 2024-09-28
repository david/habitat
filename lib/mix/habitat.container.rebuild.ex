defmodule Mix.Tasks.Habitat.Container.Rebuild do
  @shortdoc "Rebuild containers"

  use Mix.Task

  @impl true
  def run(args) do
    Mix.Task.run("habitat.container.reset", args)
    Mix.Task.run("habitat.container.sync", args)
  end
end
