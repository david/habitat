defmodule Habitat.Programs.Zoxide do
  require Logger

  def configure(%{programs: %{zoxide: true} = programs} = container) do
    Logger.info("Configuring zoxide")

    container
    |> update_in([:files], &(&1 ++ bash_files(programs) ++ zsh_files(programs)))
    |> update_in([:packages], &["zoxide" | &1])
  end

  def configure(container), do: container

  defp bash_files(%{bash: bash}) when bash, do: contents("bash")
  defp bash_files(_), do: []

  defp zsh_files(%{zsh: zsh}) when zsh, do: contents("zsh")
  defp zsh_files(_), do: []

  defp contents(shell) do
    [{{:text, "eval \"$(zoxide init #{shell})\""}, "~/.config/#{shell}/rc.d/80_zoxide.sh"}]
  end
end
