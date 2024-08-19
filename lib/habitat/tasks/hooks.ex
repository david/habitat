defmodule Habitat.Tasks.Hooks do
  require Logger

  def init(container) do
    Map.put_new(container, :hooks, %{post_sync: %{}})
  end

  def post_sync(container) do
    Enum.each(container.hooks.post_sync, fn {k, f} ->
      Logger.debug("Running hook post_sync/#{k}")
      f.(container)
    end)
  end
end
