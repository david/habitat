defmodule Mix.Tasks.Habitat do
  use Mix.Task

  alias Habitat.Container

  @requirements ["ecto.create", "ecto.migrate", "app.start"]

  def run(_) do
    Mix.Ecto.ensure_repo(Habitat.Repo, [])
    units = Code.require_file("blueprint.exs")

    {mod, _} = List.first(units)

    container = mod.config() |> Container.new()

    Container.sync_packages(container)
    Container.configure(container)
  end
end
