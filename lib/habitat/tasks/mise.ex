defmodule Habitat.Tasks.Mise do
  alias Habitat.Container
  alias Habitat.Tasks.{Packages, Shells}

  require Logger

  def init(container) do
    Map.put_new(container, :mise, [])
  end

  def pre_sync(container) do
    Logger.info("Configuring mise")

    container
    |> Shells.put_env(%{
      "MISE_DATA_DIR" => data_dir(),
      "PATH" => "#{data_dir()}/shims:${PATH}"
    })
    |> Packages.put("mise")
  end

  def sync(curr, prev) do
    Container.cmd(curr, ["sudo", "mkdir", "-p", data_dir()])
    Container.cmd(curr, ["sudo", "chown", Container.username(curr), data_dir()])

    install(curr, curr.mise)
  end

  def put(container, package, opts \\ []) do
    version =
      case opts do
        nil -> ""
        [] -> ""
        v when is_binary(v) -> "@#{v}"
        l when is_list(l) -> "@" <> Keyword.get(l, :version)
      end

    update_in(container, [:mise], &["#{package}#{version}" | &1])
  end

  defp install(_container, []) do
    Logger.info("Nothing to install")
  end

  defp install(container, packages) do
    Logger.info("Installing packages: #{inspect(packages)}")

    for p <- packages do
      Container.cmd(container, ["mise", "use", "--yes", "--global", p], %{
        "MISE_DATA_DIR" => data_dir()
      })
    end
  end

  defp data_dir(), do: "/usr/habitat/mise"
end
