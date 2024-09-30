defmodule Habitat.Tasks.SyncFiles do
  alias Habitat.{Container, Resource}

  require Logger

  def init(manifest, %{files: files}) do
    Map.put(
      manifest,
      :files,
      normalize_all(files)
    )
  end

  def init(manifest, _), do: init(manifest, %{files: %{}})

  def update(manifest, mod, spec, blueprint) do
    Logger.debug(
      "Atempting to update #{inspect(mod)}: #{inspect(spec)}, exports: #{inspect(function_exported?(mod, :files, 2))}"
    )

    if function_exported?(mod, :files, 2) do
      Logger.debug("Updating from #{mod}: #{inspect(spec)}")

      update_in(manifest, [:files], &merge_all(&1, mod.files(spec, blueprint)))
    else
      manifest
    end
  end

  defp normalize_all(files) do
    for {target, source} <- files, into: %{}, do: {target, Resource.normalize(source)}
  end

  defp merge_all(files, new_files) do
    Logger.debug("Will merge #{inspect(new_files)}")

    for {target, source} <- new_files, reduce: files do
      fs ->
        update_in(fs, [target], fn val ->
          result = Resource.merge(val, source)

          Logger.debug("Merged #{target}\n  from:\n#{inspect(val)}\n  to:\n#{inspect(result)}")

          result
        end)
    end
  end

  def sync(%{files: files}, container) do
    Logger.info("Syncing files")

    for {target, source} <- files do
      Logger.info("Syncing #{inspect(target)}")
      Logger.info("Syncing #{inspect(source)}")

      sync_path(container, target, Habitat.Resource.prepare(source))
    end
  end

  def sync_path(container, target, {:string, body}) do
    Container.write(container, target, body)
  end

  def sync_path(container, target, {:link, path}) do
    Container.link(container, target, path)
  end
end
