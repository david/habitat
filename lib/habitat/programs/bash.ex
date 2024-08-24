defmodule Habitat.Programs.Bash do
  require Logger
  use Habitat.Feature

  def pre_sync(container, _) do
    Logger.info("Configuring bash")

    container
    |> put_files(files())
    |> put_package("bash")
  end

  defp files() do
    [
      {{:string, bash_profile()}, "~/.bash_profile"},
      {{:string, bashrc()}, "~/.bashrc"}
    ]
  end

  defp bashrc() do
    """
    [[ $- == *i* ]] || return

    if [[ -d ~/.config/bash/rc.d ]] ; then
      for f in ~/.config/bash/rc.d/* ; do
        source $f
      done
    fi
    """
  end

  defp bash_profile() do
    """
    if [[ -d ~/.config/bash/profile.d ]] ; then
      for f in ~/.config/bash/profile.d/* ; do
        source $f
      done
    fi
    """
  end
end
