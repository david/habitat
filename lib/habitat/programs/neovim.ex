defmodule Habitat.Programs.Neovim do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring neovim")

    Packages.put(container, "neovim")
  end
end
