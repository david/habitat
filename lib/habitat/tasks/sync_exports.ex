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

  def sync(%{exports: exports}) do
    Logger.info("Exporting applications: #{inspect(exports)}")

    for export <- exports do
      System.cmd("distrobox-export", ["--delete", "--app", export])
      {_, 0} = System.cmd("distrobox-export", ["--app", export])
    end
  end
end
