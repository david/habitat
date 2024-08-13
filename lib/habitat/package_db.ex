defmodule Habitat.PackageDB do
  alias Habitat.{Container, Package, Packages, Snapshots}

  def ensure_prepared(container) do
    if Snapshots.none?(), do: take_snapshot(container)
  end

  # TODO: Make sure snapshots match currently installed packages
  # and update generation if not
  def sync(container) do
    did_install = install(container)
    did_uninstall = uninstall(container)

    if did_install or did_uninstall do
      take_snapshot(container)
    end
  end

  defp install(container) do
    wanted = container.spec.packages
    explicit = Container.list_packages(container, :explicit) |> Package.names()

    pending = wanted -- explicit
    changed = !Enum.empty?(pending)

    if changed do
      IO.puts("-- Installing packages:")
      IO.inspect(pending)

      container.package_manager.install(pending)
    end

    changed
  end

  defp uninstall(container) do
    base = Snapshots.list_packages(1) |> Package.names()
    wanted = container.spec.packages
    explicit = Container.list_packages(container, :explicit) |> Package.names()

    pending = (explicit -- base) -- wanted
    changed = !Enum.empty?(pending)

    if changed do
      IO.puts("-- Removing packages:")
      IO.inspect(pending)

      container.package_manager.uninstall(pending)
    end

    changed
  end

  defp take_snapshot(container) do
    Container.list_packages(container)
    |> Packages.ensure_all()
    |> Snapshots.take()
  end
end
