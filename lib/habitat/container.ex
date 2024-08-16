defmodule Habitat.Container do
  alias Habitat.{Tasks, Features}

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

    Tasks.Packages.disable(container)
  end

  def configure(container) do
    container = Features.Bash.configure(container)

    Logger.info("Configuring container #{container.name}")
    Logger.debug(container)

    Tasks.Packages.sync(container)
    Tasks.Exports.sync(container)
    Tasks.Files.sync(container)
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
