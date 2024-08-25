defmodule Habitat.Modules.Mysql do
  alias Habitat.Container

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring mysql")

    container
    # |> Packages.put(["libaio", "numactl"])
  end

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
    datadir = Path.join([container.root, ".local", "share", "mysql-data"])

    unless File.exists?(datadir) do
      # Mise.exec(
      #  container,
      #  "mysql",
      #  [
      #    "mysqld",
      #    "--initialize-insecure",
      #    "--datadir=#{datadir}"
      #  ]
      # )
    end
  end
end
