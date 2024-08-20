defmodule Habitat.Programs.Zoxide do
  require Logger
  use Habitat.Feature

  def configure(%{programs: %{zoxide: true}} = container) do
    Logger.info("Configuring zoxide")

    container
    |> put_shell_config(:bash, "zoxide", "eval \"$(zoxide init bash)\"")
    |> put_shell_config(:zsh, "zoxide", "eval \"$(zoxide init zsh)\"")
    |> put_package("zoxide")
  end

  def configure(container), do: container
end
