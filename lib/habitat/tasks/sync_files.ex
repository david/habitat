defmodule Habitat.Tasks.SyncFiles do
  alias Habitat.Resource

  require Logger

  def init(manifest, %{files: files}) do
    Map.put(manifest, :files, normalize_all(files))
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
    for {target, source} <- files, into: %{} do
      {target, Resource.normalize(source)}
    end
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

  def sync(%{files: files}) do
    Logger.info("Syncing files: #{inspect(files)}")

    for {target, source} <- files do
      sync_path(Path.expand(target), Habitat.Resource.prepare(source))
    end
  end

  def sync_path(target, {:string, body}) do
    Logger.debug("Writing to #{target}")
    Logger.debug(body)

    target |> Path.dirname() |> File.mkdir_p!()

    File.write!(target, body)
  end

  def sync_path(target, {:link, path}) do
    source = Path.join("/run/host", Path.expand(path))

    Logger.debug("Linking #{source} to #{target}")

    target |> Path.dirname() |> File.mkdir_p!()

    File.rm_rf(target)
    File.ln_s(source, target)
  end
end
