defmodule Habitat.Manifest do
  require Logger

  alias Habitat.Tasks.{SyncExports, SyncFiles, RunHooks, SyncPackages, SyncServices}

  def new(%{modules: modules} = blueprint) do
    manifest =
      %{}
      |> SyncExports.init(blueprint)
      |> SyncFiles.init(blueprint)
      |> SyncPackages.init(blueprint)
      |> RunHooks.init(blueprint)
      |> SyncServices.init(blueprint)

    for {_, mod, spec} <- modules, reduce: manifest do
      m ->
        m
        |> SyncExports.update(mod, spec, blueprint)
        |> SyncFiles.update(mod, spec, blueprint)
        |> SyncPackages.update(mod, spec, blueprint)
        |> RunHooks.update(mod, spec, blueprint)
        |> SyncServices.update(mod, spec, blueprint)
    end
  end

  def sync(manifest, %{id: id} = container) do
    Logger.info("[#{id}] Starting sync")
    Logger.debug("[#{id}] #{inspect(container)}")

    SyncFiles.sync(manifest, container)
    SyncPackages.sync(manifest, container)
    SyncExports.sync(manifest, container)
    SyncServices.sync(manifest, container)
    RunHooks.sync(:post_sync, manifest, container)
  end
end
