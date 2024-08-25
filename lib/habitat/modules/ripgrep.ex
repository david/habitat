defmodule Habitat.Modules.Ripgrep do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring ripgrep")

    install(container, "ripgrep")
  end
end
