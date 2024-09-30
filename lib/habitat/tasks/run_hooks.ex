defmodule Habitat.Tasks.RunHooks do
  require Logger

  def init(manifest, _) do
    Map.put(manifest, :hooks, [])
  end

  def update(manifest, mod, spec, _) do
    if function_exported?(mod, :post_sync, 2) do
      update_in(manifest, [:hooks], &(&1 ++ [{:post_sync, mod, spec}]))
    else
      manifest
    end
  end

  def sync(hook, %{hooks: hooks}, %{id: id} = container) do
    Logger.info("[#{id}] Running hooks")
    Logger.debug("[#{id}] #{inspect(hooks)}")

    for {hk, mod, spec} <- hooks, hk == hook, do: mod.post_sync(container, spec)
  end
end
