defmodule Habitat.Tasks.Packages do
  alias Habitat.Container

  require Logger

  # TODO: Make sure snapshots match currently installed packages
  def sync(curr, prev) do
    {to_install, to_uninstall} = changes(curr, prev)

    uninstall(curr, to_uninstall)
    install(curr, to_install)
  end

  defp changes(curr, prev) do
    {
      curr.packages -- prev.packages,
      prev.packages -- curr.packages
    }
  end

  defp install(_container, []) do
    Logger.info("Nothing to install")
  end

  defp install(container, packages) do
    Logger.info("Installing packages: #{inspect(packages)}")

    Container.install_packages(container, packages)
  end

  defp uninstall(_container, []) do
    Logger.info("Nothing to uninstall")
  end

  defp uninstall(container, packages) do
    Logger.info("Uninstalling packages #{inspect(packages)}")

    Container.uninstall_packages(container, packages)
  end
end
