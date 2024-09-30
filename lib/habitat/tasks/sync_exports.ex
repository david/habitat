defmodule Habitat.Tasks.SyncExports do
  require Logger

  def init(manifest, %{exports: exports}) do
    Map.put(manifest, :exports, exports)
  end

  def init(manifest, _), do: init(manifest, %{exports: []})

  def update(manifest, mod, _, _) do
    if function_exported?(mod, :exports, 0) do
      update_in(manifest, [:exports], &(&1 ++ mod.exports()))
    else
      manifest
    end
  end

  def sync(%{exports: exports}, container) do
    Logger.info("Exporting applications")
    Logger.debug(inspect(exports))

    for export <- exports do
      Habitat.Container.export(container, export)
    end
  end
end
