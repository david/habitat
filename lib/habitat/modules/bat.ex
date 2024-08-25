defmodule Habitat.Modules.Bat do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring bat")

    install(container, "bat")
  end
end
