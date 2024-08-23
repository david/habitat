defmodule Habitat.Programs.Starship do
  require Logger
  use Habitat.Feature

  def pre_sync(container, _) do
    Logger.info("Configuring starship")

    container
    |> put_package("starship")
    |> put_shell_config(:bash, "starship", "eval \"$(starship init bash)\"")
    |> put_shell_config(:zsh, "starship", "eval \"$(starship init zsh)\"")
  end
end
