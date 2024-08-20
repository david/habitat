defmodule Habitat.Programs.Bash do
  require Logger

  def configure(%{programs: %{bash: true}} = container) do
    Logger.info("Configuring bash")

    container
    |> update_in([:files], &(&1 ++ files()))
    |> update_in([:packages], &["bash" | &1])
  end

  def configure(container), do: container

  defp files() do
    [
      {{:text, bash_profile()}, "~/.bash_profile"},
      {{:text, bashrc()}, "~/.bashrc"}
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
