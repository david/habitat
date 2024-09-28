defmodule Habitat.Manifest do
  require Logger

  alias Habitat.{ExportList, FileList, HookList, PackageList}

  def new(%{modules: modules} = blueprint) do
    manifest =
      %{}
      |> ExportList.init(blueprint)
      |> FileList.init(blueprint)
      |> PackageList.init(blueprint)
      |> HookList.init(blueprint)

    for {_, mod, spec} <- modules, reduce: manifest do
      m ->
        m
        |> ExportList.update(mod, spec, blueprint)
        |> FileList.update(mod, spec, blueprint)
        |> PackageList.update(mod, spec, blueprint)
        |> HookList.update(mod, spec, blueprint)
    end
  end

  def sync(manifest, %{id: id} = container) do
    Logger.info("[#{id}] Starting sync")

    FileList.sync(manifest, container)
    PackageList.sync(manifest, container)
    ExportList.sync(manifest, container)
    HookList.sync(:post_sync, manifest, container)
  end
end
