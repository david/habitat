defmodule Habitat.Tasks.Packages do
  require Logger

  def sync(curr, prev) do
    uninstall(curr, prev.packages -- curr.packages)
    install(curr, curr.packages -- prev.packages)
  end

  defp install(_container, []) do
    Logger.info("Nothing to install")
  end

  defp install(container, packages) do
    Logger.info("Installing packages: #{inspect(packages)}")

    container.os.install(container, packages)
  end

  defp uninstall(_container, []) do
    Logger.info("Nothing to uninstall")
  end

  defp uninstall(container, packages) do
    Logger.info("Uninstalling packages #{inspect(packages)}")

    container.os.uninstall(container, packages)
  end
end
