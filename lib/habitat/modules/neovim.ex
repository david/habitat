defmodule Habitat.Modules.Neovim do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring neovim")

    install(container, "neovim")
  end
end
