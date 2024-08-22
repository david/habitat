defmodule Habitat.Programs.Starship do
  require Logger
  use Habitat.Feature

  def pre_sync(%{programs: %{starship: true}} = container) do
    Logger.info("Configuring starship")

    container
    |> put_shell_config(:bash, "starship", "eval \"$(starship init bash)\"")
    |> put_shell_config(:zsh, "starship", "eval \"$(starship init zsh)\"")
    |> put_package("starship")
  end

  def pre_sync(container), do: container
end
