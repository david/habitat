defmodule Habitat.Modules.Nodejs do
  use Habitat.Module

  def files(version, blueprint) when is_binary(version) do
    files(%{version: version}, blueprint)
  end

  def files(%{version: version}, blueprint) do
    [shell_env("/home/linuxbrew/.linuxbrew/opt/node@#{version}", blueprint)]
  end

  def packages(version, blueprint) when is_binary(version) do
    packages(%{version: version}, blueprint)
  end

  def packages(%{version: version} = config, _) do
    [{:brew, "node@#{version}"}, put_package_manager(config)]
  end

  defp put_package_manager(%{package_manager: :yarn}), do: {:brew, "yarn"}

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
end
