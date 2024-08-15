defmodule Habitat.PackageDB do
  alias Habitat.Container

  require Logger

  def ensure_prepared(container) do
    if empty?(container), do: take_snapshot(container)
  end

  # TODO: Make sure snapshots match currently installed packages
  # and update generation if not
  def sync(container) do
    did_install = install(container)
    did_uninstall = uninstall(container)

    if did_install or did_uninstall do
      take_snapshot(container)
    else
      Logger.info("No change to package list")
    end
  end

  defp install(container) do
    wanted = Container.list_packages(container, :wanted)
    explicit = Container.list_packages(container, :explicit)

    pending = wanted -- explicit
    changed = !Enum.empty?(pending)

    if changed do
      Logger.info("Installing packages")
      Logger.debug(pending)

      Container.install_packages(container, pending)
    end

    changed
  end

  defp uninstall(container) do
    base = earliest_snapshot(container)
    wanted = Container.list_packages(container, :wanted)
    explicit = Container.list_packages(container, :explicit)

    pending = (explicit -- base) -- wanted
    changed = !Enum.empty?(pending)

    if changed do
      Logger.info("Uninstalling packages")
      Logger.debug(pending)

      Container.uninstall_packages(container, pending)
    end

    changed
  end

  defp take_snapshot(container) do
    {:ok, contents} = Container.list_packages(container) |> JSON.encode()

    :ok =
      container
      |> path()
      |> Path.join("#{snapshot_version()}.json")
      |> File.write(contents)
  end

  defp snapshot_version() do
    %{
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      microsecond: microsecond
    } = NaiveDateTime.utc_now()

    date = Calendar.ISO.date_to_string(year, month, day, :basic)
    time = Calendar.ISO.time_to_string(hour, minute, second, microsecond, :basic)

    "#{date}.#{time}"
  end

  defp snapshots(container) do
    ensure_snapshot_root(container)

    dir = path(container)

    dir |> File.ls!() |> Enum.sort() |> Enum.map(&Path.join(dir, &1))
  end

  defp earliest_snapshot(container) do
    container |> snapshots() |> List.first() |> snapshot_contents()
  end

  defp snapshot_contents(file) do
    Logger.info("Reading contents of snapshot #{file}")

    File.read!(file) |> JSON.decode!()
  end

  defp ensure_snapshot_root(container) do
    path(container) |> File.mkdir_p()
  end

  defp root_home(), do: Path.join(System.user_home(), ".local/share/habitat")

  defp path(container), do: Path.join(root_home(), container.name)

  defp empty?(container) do
    container |> snapshots() |> Enum.empty?()
  end
end
