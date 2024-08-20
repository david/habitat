defmodule Habitat.Programs.Atuin do
  use Habitat.Feature

  def configure(%{programs: %{atuin: true}} = container) do
    Logger.info("Configuring atuin")

    container
    |> put_shell_config(:bash, "atuin", "eval \"$(atuin init bash)\"")
    |> put_shell_config(:zsh, "atuin", "eval \"$(atuin init zsh)\"")
    |> put_package("atuin")
  end

  def configure(container), do: container
end
