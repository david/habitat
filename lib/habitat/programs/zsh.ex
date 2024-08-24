defmodule Habitat.Programs.Zsh do
  alias Habitat.Container
  require Logger
  use Habitat.Feature

  def pre_sync(container, _) do
    Logger.info("Configuring zsh")

    container
    |> put_files(files())
    |> put_package("zsh")
  end

  def post_sync(%{shell: :zsh} = container, _) do
    {user, 0} = Container.cmd(container, ["whoami"])
    Container.cmd(container, ["sudo", "chsh", "--shell", "/usr/bin/zsh", String.trim(user)])
  end

  defp packages(opts) do
    ["zsh"] ++ plugins(opts)
  end

  defp plugins(%{plugins: plugins}) when is_list(plugins) do
    Enum.map(plugins || [], &{:gh, &1})
  end

  defp plugins(_), do: []

  defp files() do
    [
      {{:string, zprofile()}, "~/.zprofile"},
      {{:string, zshrc()}, "~/.zshrc"}
    ]
  end

  defp zshrc() do
    """
    [[ $- == *i* ]] || return

    if [[ -d ~/.config/zsh/rc.d ]] ; then
      for f in ~/.config/zsh/rc.d/* ; do
        source $f
      done
    fi
    """
  end

  defp zprofile() do
    """
    if [[ -d ~/.config/zsh/profile.d ]] ; then
      for f in ~/.config/zsh/profile.d/* ; do
        source $f
      done
    fi

    if [[ -d ~/.local/opt ]] ; then
      for f in ~/.local/opt/* ; do
        export PATH="$PATH:$f/bin"
      done
    fi
    """
  end
end
