defmodule Habitat.Programs.Mise do
  alias Habitat.Tasks.{Packages, Shells}
  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring mise")

    container
    |> Shells.put_env(%{
      "MISE_DATA_DIR" => "/usr/mise",
      "PATH" => "${MISE_DATA_DIR}/shims:${PATH}"
    })
    |> Packages.put("mise")
  end
end
