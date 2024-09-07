defmodule Mix.Tasks.Habitat.Create do
  @shortdoc "Create missing containers"

  use Mix.Task

  alias Habitat.{Distrobox, OS}

  @requirements ["app.start"]

  @impl true
  def run(args) do
    for arg <- args, id = String.to_atom(arg) do
      {:ok, container} = Habitat.Blueprint.get_container(id)

      os = Keyword.get(container, :os)
      root = Keyword.get(container, :root)

      Distrobox.create(arg, to_string(os), root)
      OS.get(os).post_create(id)
    end
  end
end
