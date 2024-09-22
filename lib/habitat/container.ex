defmodule Habitat.Container do
  require Logger

  def install(%{id: id}, {:apt, package, opts}) do
    Habitat.PackageManager.Apt.install(id, package, opts)
  end

  def install(%{id: id}, {:brew, package, opts}) do
    Habitat.PackageManager.Brew.install(id, package, opts)
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
