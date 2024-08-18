defmodule Habitat.Features.Zoxide do
  require Logger

  def configure(%{features: %{zoxide: true} = features} = container) do
    Logger.info("Configuring zoxide")

    container
    |> update_in([:files], &(&1 ++ files(features)))
    |> update_in([:packages], &["zoxide" | &1])
  end

  def configure(container), do: container

  defp files(%{bash: true}) do
    [
      {{:text, "eval \"$(zoxide init bash)\""}, "~/.config/bash/rc.d/80_zoxide.sh"}
    ]
  end
end
