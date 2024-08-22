defmodule Mix.Tasks.Habitat.Sync do
  @shortdoc "Update system configuration"
  use Mix.Task
  import Mix.Habitat
  alias Habitat.Container

  @impl true
  def run(args) do
    blueprint().containers()
    |> Enum.filter(&(Enum.empty?(args) || &1.name in args))
    |> Enum.each(&Container.sync/1)
  end
end
