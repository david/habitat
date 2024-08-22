defmodule Habitat.Programs.Zsh do
  alias Habitat.Container
  require Logger
  use Habitat.Feature

  def configure(%{programs: %{zsh: zsh}} = container) when zsh do
    Logger.info("Configuring zsh")

    container
    |> put_files(files())
    |> put_package("zsh")
    |> put_hook(:post_sync, :zsh, fn
      %{shell: :zsh} ->
        {user, 0} = Container.cmd(container, ["whoami"])
        Container.cmd(container, ["sudo", "chsh", "--shell", "/usr/bin/zsh", String.trim(user)])

      _ ->
        container
    end)
  end

  def configure(container), do: container

  defp packages(opts) do
    ["zsh"] ++ plugins(opts)
  end

  defp plugins(%{plugins: plugins}) when is_list(plugins) do
    Enum.map(plugins || [], &{:gh, &1})
  end

  defp plugins(_), do: []

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

    if [[ -d ~/.local/opt ]] ; then
      for f in ~/.local/opt/* ; do
        export PATH="$PATH:$f/bin"
      done
    fi
    """
  end
end
