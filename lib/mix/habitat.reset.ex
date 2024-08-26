defmodule Mix.Tasks.Habitat.Reset do
  @shortdoc "Reset containers"

  use Mix.Task

  @impl true
  def run(names) do
    Mix.Task.run("habitat.delete", names)
    Mix.Task.run("habitat.create", names)
  end
end
