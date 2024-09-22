defmodule Habitat.Manifest do
  require Logger

  def new(%{modules: modules} = blueprint) do
    manifest =
      %{blueprint: blueprint}
      |> Habitat.FileList.init(blueprint)
      |> Habitat.PackageList.init(blueprint)

    for {_, mod, spec} <- modules, reduce: manifest do
      m -> mod.sync(m, spec, blueprint)
    end
  end

  def sync(manifest, %{id: id} = container) do
    Logger.info("[#{id}] Starting sync")
    Logger.debug("[#{id}] #{inspect(manifest)}")

    Habitat.FileList.sync(manifest, container)
    Habitat.PackageList.sync(manifest, container)
    # sync_exports(c)
  end
end
