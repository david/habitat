defmodule Mix.Tasks.Habitat.Reset do
  @shortdoc "Reset containers"

  use Mix.Task

  @impl true
  def run(args) do
    Mix.Task.run("habitat.delete", args)
    Mix.Task.run("habitat.create", args)
  end
end
