defmodule Habitat.Modules.Lsd do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring lsd")

    install(container, "lsd")
  end
end
