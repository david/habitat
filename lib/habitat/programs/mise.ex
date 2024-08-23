defmodule Habitat.Programs.Mise do
  use Habitat.Feature

  def pre_sync(container, _) do
    Logger.info("Configuring mise")

    container
    |> put_shell_config(:bash, "mise", "eval \"$(mise activate bash)\"")
    |> put_shell_config(:zsh, "mise", "eval \"$(mise activate zsh)\"")
    |> put_package("mise")
  end
end
