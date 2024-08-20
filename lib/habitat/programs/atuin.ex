defmodule Habitat.Programs.Atuin do
  require Logger

  def configure(%{programs: %{atuin: true} = programs} = container) do
    Logger.info("Configuring atuin")

    container
    |> update_in([:files], &(&1 ++ files(programs)))
    |> update_in([:packages], &["atuin" | &1])
  end

  def configure(container), do: container

  defp files(programs) do
    Enum.filter(
      [
        if(programs.bash, do: contents("bash")),
        if(programs.zsh, do: contents("zsh"))
      ],
      &Function.identity/1
    )
  end

  defp contents(shell) do
    {{:text, "eval \"$(atuin init #{shell})\""}, "~/.config/#{shell}/rc.d/80_atuin.sh"}
  end
end
