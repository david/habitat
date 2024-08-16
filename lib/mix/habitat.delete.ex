defmodule Mix.Tasks.Habitat.Delete do
  @shortdoc "Delete one or more containers"

  use Mix.Task
  import Mix.Habitat
  alias Habitat.Container

  @impl true
  def run(args) do
    blueprint().containers()
    |> Enum.filter(&(&1.name in args))
    |> Enum.each(&Container.delete/1)
  end
end
