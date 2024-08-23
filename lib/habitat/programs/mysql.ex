defmodule Habitat.Programs.Mysql do
  alias Habitat.Container
  use Habitat.Feature

  def pre_sync(%{programs: %{mysql: mysql}} = container) when is_enabled(mysql) do
    Logger.info("Configuring mysql")

    container
    |> put_packages(["libaio", "numactl"])
    |> put_package(:mise, "mysql", version: version(mysql))
  end

  def pre_sync(container), do: container

  defp version(true), do: nil
  defp version(v) when is_binary(v), do: v
  defp version(opts) when is_list(opts), do: Keyword.get(opts, :version, version(true))

  def post_sync(%{programs: %{mysql: mysql}} = container) when is_enabled(mysql) do
    fix_ncurses(container)
    initialize_database(container)
  end

  def post_sync(_), do: nil

  defp fix_ncurses(container) do
    # TODO: Look into starting a server inside the container
    # instead of having to do these kinds of things
    Container.cmd(container, [
      "ln",
      "-sf",
      "/usr/lib64/libncursesw.so.6",
      "/user/lib64/libncurses.so.6"
    ])
  end

  def initialize_database(container) do
    Container.cmd(container, [
      "mysqld",
      "--initialize-insecure",
      "--datadir=#{Path.join([container.root, ".local", "share", "databases"])}"
    ])
  end
end
