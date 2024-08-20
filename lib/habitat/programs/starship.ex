defmodule Habitat.Programs.Starship do
  require Logger

  def configure(%{programs: %{starship: true} = programs} = container) do
    Logger.info("Configuring starship")

    container
    |> update_in([:files], &(&1 ++ files(programs)))
    |> update_in([:packages], &["starship" | &1])
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
    {{:text, "eval \"$(starship init #{shell})\""}, "~/.config/#{shell}/rc.d/80_starship.sh"}
  end
end
