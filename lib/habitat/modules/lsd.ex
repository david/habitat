defmodule Habitat.Modules.Lsd do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring lsd")

    Packages.put(container, "lsd")
  end
end
