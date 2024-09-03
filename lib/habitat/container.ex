defmodule Habitat.Container do
  alias Habitat.{Builder, Distrobox, Exports, Files, OS}

  require Logger

  use GenServer

  def start_link(%{id: id, os: os, root: root} = meta) do
    GenServer.start_link(__MODULE__, %{id: id, os: os, root: root}, name: id)
  end

  def init(meta) do
    meta
    |> Map.merge(%{exports: [], files: %{}, packages: []})
    |> then(&{:ok, &1})
  end

  ###

  def create(id) do
    GenServer.call(id, :create, :infinity)
  end

  def delete(id) do
    GenServer.call(id, :delete)
  end

  def stop(id) do
    GenServer.call(id, :stop)
  end

  def sync(id) do
    GenServer.call(id, :sync, :infinity)
  end

  ###

  def export(id, apps) do
    GenServer.cast(id, {:export, apps})
  end

  def install(id, packages) do
    GenServer.cast(id, {:install, packages})
  end

  def insert(id, path, content) do
    GenServer.cast(id, {:insert, path, content})
  end

  ###

  def handle_call(:create, _, %{os: os} = container) do
    :ok = Distrobox.create(container)

    {:reply, :ok, container}
  end

  def handle_call(:delete, _, container) do
    :ok = Distrobox.delete(container)

    {:reply, :ok, container}
  end

  def handle_cast({:export, apps}, %{id: id} = container) do
    Logger.debug("[#{id}] Queueing #{inspect(apps)} for export")

    {:noreply, update_in(container, [:exports], &(&1 ++ apps))}
  end

  def handle_cast({:insert, path, content}, container) when is_binary(content) do
    {:noreply,
     update_in(
       container,
       [:files, String.replace(path, ~r/^~/, container.root)],
       fn
         nil -> {content, []}
         {_, tags} -> {content, tags}
       end
     )}
  end

  def handle_cast({:insert, path, tags}, container) when is_list(tags) do
    {:noreply,
     update_in(
       container,
       [:files, String.replace(path, ~r/^~/, container.root)],
       fn
         nil ->
           {nil, tags}

         {content, original_tags} ->
           {content, Keyword.merge(original_tags, tags, fn _, va, vb -> va <> "\n" <> vb end)}
       end
     )}
  end

  def handle_cast({:install, packages}, %{id: id} = container) do
    Logger.debug("[#{id}] Queueing #{inspect(packages)} for installation")

    {:noreply, update_in(container, [:packages], &(&1 ++ packages))}
  end

  def handle_call(:stop, _, container) do
    :ok = Distrobox.stop(container)

    {:reply, :ok, container}
  end

  def handle_call(:sync, _, %{id: id} = container) do
    Logger.info("[#{id}] Starting sync")
    Logger.debug("[#{id}] #{inspect(container)}")

    container =
      container
      |> update_in([:files], fn files ->
        for {path, {content, tags}} <- files, !is_nil(content) do
          {path, {:string, EEx.eval_string(content, assigns: tags)}}
        end
      end)

    Files.sync(container)
    sync_packages(container)
    sync_exports(container)

    {:reply, :ok, container}
  end

  ###

  def chsh(container, path) do
    cmd(container, ["sudo", "chsh", "--shell", path, userid(container)])
  end

  def cmd(id, args, opts \\ []) do
    Distrobox.cmd(id, args, opts)
  end

  def userid(container) do
    {user, 0} = __MODULE__.cmd(container, ["whoami"])

    String.trim(user)
  end

  defp sync_packages(%{id: id, os: os, packages: packages}) do
    Logger.info("[#{id}] Syncing packages")
    Logger.debug("[#{id}] #{inspect(packages)}")

    OS.get(os).install(id, for(p <- packages, !is_tuple(p), do: p))
    Builder.sync(id, for(p <- packages, is_tuple(p), do: p))
  end

  def sync_exports(%{id: id, exports: exports}) do
    Logger.info("[#{id}] Syncing exports")
    Logger.debug("[#{id}] #{inspect(exports)}")

    for app <- exports do
      Distrobox.cmd(id, ["distrobox-export", "--delete", "--app", app])

      :ok = Distrobox.cmd(id, ["distrobox-export", "--app", app])
    end
  end
end
