defmodule Habitat.Modules.Mysql do
  use Habitat.Module

  def packages(version, blueprint) when is_binary(version) do
    packages(%{version: version}, blueprint)
  end

  def packages(%{version: version}, _) do
    [{:brew, "mysql@#{version}"}]
  end

  def files(version, blueprint) do
    [shell_env("/home/linuxbrew/.linuxbrew/opt/mysql@#{version}", blueprint)]
  end

  def post_install_hook(id) do
    # Distrobox.cmd(id, mysqld("--initialize-insecure", "--datadir="))
  end

  defp shell_env(path, %{shell: :bash}) do
    {"~/.bash_profile",
     env: """
     export PATH=#{path}/bin:$PATH
     export LDFLAGS="$LDFLAGS -L#{path}/lib"
     export CPPFLAGS="$CPPFLAGS -I#{path}/include"
     """}
  end

  defp shell_env(path, %{shell: :fish}) do
    {"~/.config/fish/config.fish",
     env: """
     fish_add_path --prepend --path #{path}/bin
     set -gx LDFLAGS "$LDFLAGS -L#{path}/lib"
     set -gx CPPFLAGS "$CPPFLAGS -I#{path}/include"
     """}
  end

  defp shell_env(path, %{shell: :zsh}) do
    {"~/.zshrc",
     env: """
     export PATH=#{path}/bin:$PATH
     export LDFLAGS="$LDFLAGS -L#{path}/lib"
     export CPPFLAGS="$CPPFLAGS -I#{path}/include"
     """}
  end

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
