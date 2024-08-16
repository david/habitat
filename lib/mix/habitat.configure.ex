defmodule Mix.Tasks.Habitat.Configure do
  @shortdoc "Update system configuration"
  use Mix.Task
  import Mix.Habitat
  alias Habitat.Container

  @impl true
  def run(_) do
    for c <- blueprint().containers(), do: Container.configure(c)
  end
end
