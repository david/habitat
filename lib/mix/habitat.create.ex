defmodule Mix.Tasks.Habitat.Create do
  @shortdoc "Create missing containers"

  use Mix.Task

  alias Habitat.{Distrobox, OS}

  @requirements ["app.start"]

  @impl true
  def run(names) do
    for name <- names, id = String.to_atom(name) do
      {:ok, %{os: os, root: root}} = Habitat.Blueprint.get_container(id)

      IO.puts(os)

      Distrobox.create(name, os.image(), root)
      os.post_create(id)
    end
  end
end
