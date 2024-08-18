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
    Logger.info("Configuring container #{container.name}")
    Logger.debug(container)

    latest = __MODULE__.State.latest(container)

    container =
      container
      |> Features.Atuin.configure()
      |> Features.Bash.configure()
      |> Features.Zoxide.configure()
      |> Tasks.Files.expand_mappings()

    Tasks.Packages.sync(container, latest)
    Tasks.Files.sync(container, latest)
    Tasks.Exports.sync(container, latest)

    __MODULE__.State.save(container, latest)
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

    def latest(container) do
      file =
        container.root
        |> files()
        |> List.first()

      (file && load(file)) || %{exports: [], files: [], packages: []}
    end

    def save(curr, prev) do
      Logger.info("Saving container state")

      next =
        curr
        |> update_in([:files], &Enum.map(&1, fn {_, to} -> to end))
        |> Map.take([:exports, :files, :packages])

      if next != prev do
        contents =
          next
          |> JSON.encode!()
          |> tap(&Logger.debug(&1))

        curr.root
        |> root()
        |> Path.join("#{version()}.json")
        |> File.write!(contents)
      end
    end

    defp load(file) do
      Logger.info("Reading snapshot #{file}")

      %{"exports" => exports, "files" => files, "packages" => packages} =
        File.read!(file) |> JSON.decode!()

      %{exports: exports, files: files, packages: packages}
    end

    defp files(root) do
      r = root(root)

      r
      |> tap(&ensure_root/1)
      |> File.ls!()
      |> Enum.sort()
      |> Enum.reverse()
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
