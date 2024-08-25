defmodule Habitat.Modules.Fzf do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring fzf")

    install(container, "fzf")
  end
end
