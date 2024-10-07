defmodule Habitat.Modules.Mysql do
  use Habitat.Module

  def files(version, blueprint) do
    [shell_env("/home/linuxbrew/.linuxbrew/opt/mysql@#{version}", blueprint)]
  end

  def packages(version, blueprint) when is_binary(version) do
    packages(%{version: version}, blueprint)
  end

  def packages(%{version: version}, _) do
    [{:brew, "mysql@#{version}"}]
  end

  def post_sync(spec) do
    if !File.dir?(datadir()) do
      System.cmd(mysqld(spec), ["--initialize-insecure", "--datadir=#{datadir()}"])
    end
  end

  def services(_) do
    [mysqld: [command: "mysqld --datadir=#{datadir()}"]]
  end

  defp datadir() do
    Path.join([Path.expand("~"), ".local", "share", "mysql-data"])
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

  defp mysqld(version) when is_binary(version) do
    "/home/linuxbrew/.linuxbrew/opt/mysql@#{version}/bin/mysqld"
  end
end
