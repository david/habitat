defmodule Habitat.Modules.Zsh do
  use Habitat.Module

  alias Habitat.Files

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring zsh")

    install("zsh")

    container
    |> Files.put_string(zprofile(), "~/.zprofile")
    |> Files.put_string(zshrc(), "~/.zshrc")
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
    """
  end
end
