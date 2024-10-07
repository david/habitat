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

  def sync(manifest, container) do
    Logger.info("Starting sync")
    Logger.debug(inspect(container))

    SyncFiles.sync(manifest)
    SyncPackages.sync(manifest)
    SyncExports.sync(manifest)
    SyncServices.sync(manifest)
    RunHooks.sync(:post_sync, manifest)
  end
end
