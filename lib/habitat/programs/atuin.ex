defmodule Habitat.Programs.Atuin do
  require Logger

  def configure(%{programs: %{atuin: true} = programs} = container) do
    Logger.info("Configuring atuin")

    container
    |> update_in([:files], &(&1 ++ bash_files(programs) ++ zsh_files(programs)))
    |> update_in([:packages], &["atuin" | &1])
  end

  def configure(container), do: container

  defp bash_files(%{bash: bash}) when not is_nil(bash), do: contents("bash")
  defp bash_files(_), do: []

  defp zsh_files(%{zsh: zsh}) when not is_nil(zsh), do: contents("zsh")
  defp zsh_files(_), do: []

  defp contents(shell) do
    [{{:text, "eval \"$(atuin init #{shell})\""}, "~/.config/#{shell}/rc.d/80_atuin.sh"}]
  end
end
