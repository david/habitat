defmodule Habitat.Programs.Mise do
  use Habitat.Feature

  def pre_sync(container, _) do
    Logger.info("Configuring mise")

    container
    |> put_env(%{
      "MISE_DATA_DIR" => "/usr/mise",
      "PATH" => "${MISE_DATA_DIR}/shims:${PATH}"
    })
    |> put_package("mise")
  end
end
