defmodule Mix.Tasks.Habitat.Rebuild do
  @shortdoc "Rebuild containers"

  use Mix.Task

  @impl true
  def run(args) do
    Mix.Task.run("habitat.reset", args)
    Mix.Task.run("habitat.sync", args)
  end
end
