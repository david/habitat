defmodule Habitat.Container do
  alias Habitat.{Distrobox, Exports, Files, Packages, Modules, OS, Shells}

  require Logger

  def create(container) do
    Logger.info("Creating container #{container.name}")

    Distrobox.create(container)

    OS.get(container.os).post_create(container)
  end

  def delete(container) do
    Logger.info("Deleting container #{container.name}")

    Distrobox.stop(container)
    Distrobox.rm(container)
  end

  def sync(container) do
    Logger.info("Configuring container #{container.name}")
    Logger.debug(container)

    container =
      container
      |> Exports.init()
      |> Files.init()
      |> Packages.init()
      |> Shells.init()
      |> Modules.pre_sync()
      |> Shells.pre_sync()
      |> Files.pre_sync()

    Files.sync(container)
    Packages.sync(container)
    Exports.sync(container)
    Shells.sync(container)

    Modules.post_sync(container)
  end

  def cmd(container, args, opts \\ []) do
    Distrobox.cmd(container, args, opts)
  end

  def username(container) do
    {user, 0} = __MODULE__.cmd(container, ["whoami"])

    String.trim(user)
  end
end
