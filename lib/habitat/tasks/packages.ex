defmodule Habitat.Tasks.Packages do
  require Logger

  def init(container) do
    Map.put_new(container, :packages, [])
  end

  def put(container, package) when is_binary(package) do
    update_in(container, [:packages], &[package | &1])
  end

  def put(container, packages) when is_list(packages) do
    update_in(container, [:packages], &(&1 ++ packages))
  end

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
