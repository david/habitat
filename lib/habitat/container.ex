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

    __MODULE__.State.delete(container)
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

  defmodule State do
    def delete(container) do
      db_path = root(container.root)

      Logger.debug("Deleting container database #{db_path}")

      File.rm_rf!(db_path)
    end

    def load(file) do
      Logger.info("Reading snapshot #{file}")

      %{"packages" => packages} = File.read!(file) |> JSON.decode!()

      %{packages: packages}
    end

    def save(container) do
      Logger.info("Saving container state")

      {:ok, contents} =
        %{packages: container.packages}
        |> JSON.encode()

      :ok =
        container.root
        |> root()
        |> Path.join("#{version()}.json")
        |> File.write(contents)
    end

    def files(container) do
      r = root(container.root)

      r
      |> tap(&ensure_root/1)
      |> File.ls!()
      |> Enum.sort()
      |> Enum.map(&Path.join(r, &1))
    end

    defp ensure_root(root) do
      File.mkdir_p(root)
    end

    defp root(base), do: Path.join([base, ".local", "share", "habitat"])

    defp version() do
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
  end
end
