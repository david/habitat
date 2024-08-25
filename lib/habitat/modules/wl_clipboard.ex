defmodule Habitat.Modules.WlClipboard do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring wl-clipboard")

    install(container, "wl-clipboard")
  end
end
