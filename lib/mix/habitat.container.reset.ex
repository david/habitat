defmodule Mix.Tasks.Habitat.Container.Reset do
  @shortdoc "Reset containers"

  use Mix.Task

  @impl true
  def run(names) do
    Mix.Task.run("habitat.container.delete", names)
    Mix.Task.run("habitat.container.create", names)
  end
end
