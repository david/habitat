defmodule Habitat.Programs.Zsh do
  require Logger
  use Habitat.Feature

  def pre_sync(container, _) do
    Logger.info("Configuring zsh")

    container
    |> put_string(zprofile(), "~/.zprofile")
    |> put_string(zshrc(), "~/.zshrc")
    |> put_package("zsh")
  end

  defp packages(opts) do
    ["zsh"] ++ plugins(opts)
  end

  defp plugins(%{plugins: plugins}) when is_list(plugins) do
    Enum.map(plugins || [], &{:gh, &1})
  end

  defp plugins(_), do: []

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
