defmodule Habitat.Programs.Zoxide do
  require Logger

  def configure(%{programs: %{zoxide: true} = programs} = container) do
    Logger.info("Configuring zoxide")

    container
    |> update_in([:files], &(&1 ++ files(programs)))
    |> update_in([:packages], &["zoxide" | &1])
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
    {{:text, "eval \"$(zoxide init #{shell})\""}, "~/.config/#{shell}/rc.d/80_zoxide.sh"}
  end
end
