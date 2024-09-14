defmodule Habitat.PackageList do
  require Logger

  def sync(%{id: id, packages: packages} = container) do
    Logger.info("[#{id}] Syncing packages")
    Logger.debug("[#{id}] #{inspect(packages)}")

    Habitat.Distrobox.cmd(
      to_string(id),
      ["/home/linuxbrew/.linuxbrew/bin/brew", "install"] ++ packages
    )
  end
end
