defmodule Habitat.Modules.Neovim do
  use Habitat.Module

  def pre_sync(container, _) do
    install(container, "neovim")
  end
end
