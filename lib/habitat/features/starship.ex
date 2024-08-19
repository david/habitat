defmodule Habitat.Features.Starship do
  require Logger

  def configure(%{features: %{starship: true} = features} = container) do
    Logger.info("Configuring starship")

    container
    |> update_in([:files], &(&1 ++ files(features)))
    |> update_in([:packages], &["starship" | &1])
  end

  def configure(container), do: container

  defp files(%{bash: true}) do
    contents("bash")
  end

  defp files(%{zsh: true}) do
    contents("zsh")
  end

  defp contents(shell) do
    [
      {{:text, "eval \"$(starship init #{shell})\""}, "~/.config/#{shell}/rc.d/80_starship.sh"}
    ]
  end
end
