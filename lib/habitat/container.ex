defmodule Habitat.Container do
  alias Habitat.{PackageDB, Traits}

  require Logger

  def create(container) do
    Logger.info("Creating container #{container.name}")

    {_, 0} =
      System.cmd("distrobox-host-exec", [
        "distrobox",
        "create",
        "--image",
        to_string(container.os) <> ":latest",
        "--name",
        container.name,
        "--home",
        container.root
      ])
  end

  def delete(container) do
    Logger.info("Deleting container #{container.name}")

    System.cmd("distrobox-host-exec", ["distrobox", "stop", container.name])
    System.cmd("distrobox-host-exec", ["distrobox", "rm", container.name])

    PackageDB.delete(container)
  end

  def configure(container) do
    container = Traits.Shell.pre_configure(container)

    Logger.info("Configuring container #{container.name}")
    Logger.debug(container)

    {installed, uninstalled} = PackageDB.sync(container)

    Traits.Export.post_install(container)
    Traits.Files.post_install(container)
  end

  def cmd(container, args) do
    System.cmd(
      "distrobox-host-exec",
      ["distrobox", "enter", "--name", container.name, "--"] ++ args
    )
  end

  def list_packages(container, filter \\ :all) do
    package_manager(container).list(container, filter)
  end

  def install_packages(container, packages) do
    package_manager(container).install(container, packages)
  end

  def uninstall_packages(container, packages) do
    package_manager(container).uninstall(container, packages)
  end

  def package_manager(container) do
    case container.os do
      :archlinux -> Habitat.PackageManager.Pacman
    end
  end
end
