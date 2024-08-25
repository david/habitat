defmodule Habitat.Modules.Bat do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring bat")

    Packages.put(container, "bat")
  end
end
