defmodule Habitat.Tasks.Mise do
  alias Habitat.Container

  require Logger

  def init(container) do
    Map.put_new(container, :mise, [])
  end

  def sync(curr, prev) do
    install(curr, curr.mise -- prev.mise)
  end

  def put(container, package, opts \\ []) do
    version =
      case opts do
        v when is_binary(v) -> "@#{v}"
        l when is_list(l) -> "@" <> Keyword.get(l, :version)
        [] -> ""
        nil -> ""
      end

    update_in(container, [:mise], &["#{package}#{version}" | &1])
  end

  defp install(_container, []) do
    Logger.info("Nothing to install")
  end

  defp install(container, packages) do
    Logger.info("Installing packages: #{inspect(packages)}")

    for p <- packages do
      Container.cmd(container, ["mise", "use", "--yes", "--global", p])
    end
  end

  defp uninstall(_container, []) do
    Logger.info("Nothing to uninstall")
  end

  defp uninstall(container, packages) do
    Logger.info("Uninstalling packages #{inspect(packages)}")

    container.os.uninstall(container, packages)
  end
end
