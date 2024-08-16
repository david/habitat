defmodule Habitat.Tasks.Packages do
  alias Habitat.Container

  require Logger

  # TODO: Make sure snapshots match currently installed packages
  def sync(container) do
    {to_install, to_uninstall} = changes(container)

    uninstall(container, to_uninstall)
    install(container, to_install)

    unless Enum.empty?(to_install) and Enum.empty?(to_uninstall) do
      Container.State.save(container)
    end
  end

  defp changes(container) do
    snaps = Container.State.files(container)

    latest =
      if Enum.empty?(snaps) do
        %{explicit: []}
      else
        snaps |> List.first() |> Container.State.load()
      end

    wanted = container.packages
    to_install = wanted -- latest.explicit
    to_uninstall = latest.explicit -- wanted

    {to_install, to_uninstall}
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
