defmodule Habitat.Container do
  require Logger

  def sync(%{id: id} = manifest) do
    Logger.info("[#{id}] Starting sync")
    Logger.debug("[#{id}] #{inspect(manifest)}")

    Habitat.FileList.sync(manifest)
    Habitat.PackageList.sync(manifest)
    # sync_exports(c)
  end

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

  def sync_exports(%{id: id, exports: exports}) do
    Logger.info("[#{id}] Syncing exports")
    Logger.debug("[#{id}] #{inspect(exports)}")

    for app <- exports do
      Distrobox.cmd(id, ["distrobox-export", "--delete", "--app", app])

      :ok = Distrobox.cmd(id, ["distrobox-export", "--app", app])
    end
  end
end
