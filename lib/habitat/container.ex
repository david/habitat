defmodule Habitat.Container do
  alias Habitat.{PackageDB, Traits}

  require Logger

  defstruct [:exports, :files, :home, :name, :os, :packages]

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
        container.home
      ])
  end

  def cmd(container, args) do
    System.cmd(
      "distrobox-host-exec",
      ["distrobox", "enter", "--name", container.name, "--"] ++ args
    )
  end

  def configure(opts) do
    container = struct(__MODULE__, opts)

    Logger.info("Configuring container #{container.name}")
    Logger.debug(container)

    {installed, uninstalled} = PackageDB.sync(container)

    Traits.Export.post_install(container)
    Traits.Files.post_install(container)
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
