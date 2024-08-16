defmodule Habitat.Tasks.Packages do
  alias Habitat.Container

  require Logger

  defmodule Snapshot do
    defstruct [:installed, :explicit]
  end

  alias Habitat.Tasks.Packages.Snapshot

  # TODO: Make sure snapshots match currently installed packages
  def sync(container) do
    ensure_root(container)

    {to_install, to_uninstall} = changes(container)

    uninstall(container, to_uninstall)
    install(container, to_install)

    unless Enum.empty?(to_install) and Enum.empty?(to_uninstall) do
      take_snapshot(container)
    end
  end

  def disable(container) do
    db_path = path(container)

    Logger.debug("Deleting container database #{db_path}")

    File.rm_rf!(path(container))
  end

  defp changes(container) do
    snaps = snapshots(container)

    latest =
      if Enum.empty?(snaps) do
        %{explicit: []}
      else
        snaps |> List.first() |> snapshot()
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

  defp take_snapshot(container) do
    Logger.info("Saving snapshot")

    {:ok, contents} =
      %{
        installed: Container.list_packages(container),
        explicit: container.packages
      }
      |> JSON.encode()

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
    dir = path(container)

    dir |> File.ls!() |> Enum.sort() |> Enum.map(&Path.join(dir, &1))
  end

  defp snapshot(file) do
    Logger.info("Reading snapshot #{file}")

    %{"installed" => installed, "explicit" => explicit} = File.read!(file) |> JSON.decode!()

    %Snapshot{installed: installed, explicit: explicit}
  end

  defp ensure_root(container) do
    container |> path() |> File.mkdir_p()
  end

  defp path(container), do: Path.join([container.root, ".local", "share", "habitat"])
end
