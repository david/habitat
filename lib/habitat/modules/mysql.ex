defmodule Habitat.Modules.Mysql do
  use Habitat.Module
  #
  # def pre_sync(container_id, _, _) do
  #   put_package(container_id, "libaio")
  #   put_package(container_id, {"mysql", url()})
  # end
  #
  # def post_sync(container, _) do
  #   initialize_database(container)
  # end
  #
  # def initialize_database(container) do
  #   datadir = Path.join([container.root, ".local", "share", "mysql-data"])
  #
  #   unless File.exists?(datadir) do
  #     Container.cmd(
  #       container,
  #       [
  #         "mysqld",
  #         "--initialize-insecure",
  #         "--datadir=#{datadir}"
  #       ]
  #     )
  #   end
  # end
  #
  # def url() do
  #   "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-8.0.39-linux-glibc2.28-x86_64.tar.xz"
  # end
end
