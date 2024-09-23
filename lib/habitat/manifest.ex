defmodule Habitat.Manifest do
  require Logger

  alias Habitat.{ExportList, FileList, PackageList}

  def new(%{modules: modules} = blueprint) do
    manifest =
      %{blueprint: blueprint}
      |> ExportList.init(blueprint)
      |> FileList.init(blueprint)
      |> PackageList.init(blueprint)

    for {_, mod, spec} <- modules, reduce: manifest do
      m ->
        m
        |> ExportList.update(mod, spec, blueprint)
        |> FileList.update(mod, spec, blueprint)
        |> PackageList.update(mod, spec, blueprint)
    end
  end

  def sync(manifest, %{id: id} = container) do
    Logger.info("[#{id}] Starting sync")
    Logger.debug("[#{id}] #{inspect(manifest)}")

    Habitat.FileList.sync(manifest, container)
    Habitat.PackageList.sync(manifest, container)
    Habitat.ExportList.sync(manifest, container)
  end
end
