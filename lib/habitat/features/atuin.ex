defmodule Habitat.Features.Atuin do
  require Logger

  def configure(%{features: %{atuin: true} = features} = container) do
    Logger.info("Configuring atuin")

    container
    |> update_in([:files], &(&1 ++ files(features)))
    |> update_in([:packages], &["atuin" | &1])
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
      {{:text, "eval \"$(atuin init #{shell})\""}, "~/.config/#{shell}/rc.d/80_atuin.sh"}
    ]
  end
end
