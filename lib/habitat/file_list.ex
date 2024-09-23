defmodule Habitat.FileList do
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
    if function_exported?(mod, :files, 2) do
      update_in(manifest, [:files], &merge_all(&1, mod.files(spec, blueprint)))
    else
      manifest
    end
  end

  defp normalize_all(files) do
    for {target, source} <- files, do: {target, Habitat.Resource.normalize(source)}
  end

  defp merge_all(files, new_files) do
    for {target, source} <- files,
        {ntarget, nsource} <- new_files,
        target == ntarget,
        into: %{} do
      {target, Habitat.Resource.merge(source, nsource)}
    end
  end

  def sync(%{files: files}, container) do
    Logger.info("Syncing files")
    Logger.debug(inspect(files))

    for {target, source} <- files do
      sync_path(container, target, Habitat.Resource.prepare(source))
    end
  end

  def sync_path(container, target, {:string, body}) do
    Container.write(container, target, body)
  end
end
