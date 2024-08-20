defmodule Habitat.Programs.Zsh do
  alias Habitat.Container
  require Logger

  def configure(%{programs: %{zsh: zsh}, shell: shell} = container) when not is_nil(zsh) do
    Logger.info("Configuring zsh")

    container
    |> update_in([:files], &(&1 ++ files()))
    |> update_in([:packages], &["zsh" | &1])
    |> update_in([:hooks, :post_sync], fn hooks ->
      if shell == :zsh do
        {user, 0} = Container.cmd(container, ["whoami"])

        Map.put(
          hooks,
          :zsh,
          &Container.cmd(&1, ["sudo", "chsh", "--shell", "/usr/bin/zsh", String.trim(user)])
        )
      else
        hooks
      end
    end)
  end

  def configure(container), do: container

  def post_sync(_), do: nil

  defp files() do
    [
      {{:text, zprofile()}, "~/.zprofile"},
      {{:text, zshrc()}, "~/.zshrc"}
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
    """
  end
end
