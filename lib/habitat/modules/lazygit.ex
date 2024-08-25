defmodule Habitat.Modules.Lazygit do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring lazygit")

    Packages.put(container, "lazygit")
  end
end
