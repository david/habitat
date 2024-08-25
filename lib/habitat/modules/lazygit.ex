defmodule Habitat.Modules.Lazygit do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring lazygit")

    install(container, "lazygit")
  end
end
