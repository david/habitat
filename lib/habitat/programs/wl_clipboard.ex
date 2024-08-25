defmodule Habitat.Programs.WlClipboard do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring wl-clipboard")

    Packages.put(container, "wl-clipboard")
  end
end
