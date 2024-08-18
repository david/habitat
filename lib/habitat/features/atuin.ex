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
    [
      {{:text, "eval \"$(atuin init bash)\""}, "~/.config/bash/rc.d/80_atuin.sh"}
    ]
  end
end
