defmodule Habitat.Programs.Mysql do
  alias Habitat.Container
  use Habitat.Feature

  def pre_sync(container, spec) do
    Logger.info("Configuring mysql")

    container
    |> put_packages(["libaio", "numactl"])
    |> put_package(:mise, "mysql", version: version(spec))
  end

  defp version([]), do: nil
  defp version(v) when is_binary(v), do: v
  defp version(opts) when is_list(opts), do: Keyword.get(opts, :version, version([]))

  def post_sync(container, _) do
    fix_ncurses(container)
    initialize_database(container)
  end

  defp fix_ncurses(container) do
    # TODO: Look into starting a server inside the container
    # instead of having to do these kinds of things
    Container.cmd(container, [
      "sudo",
      "ln",
      "-sf",
      "/usr/lib64/libncursesw.so.6",
      "/usr/lib64/libncurses.so.6"
    ])
  end

  def initialize_database(container) do
    Container.cmd(container, [
      "mise",
      "exec",
      "mysql",
      "--",
      "mysqld",
      "--initialize-insecure",
      "--datadir=#{Path.join([container.root, ".local", "share", "databases"])}"
    ])
  end
end
