defmodule Habitat.Modules.Neovim do
  use Habitat.Module

  def packages(_, _) do
    ["neovim"]
  end

  def files(%{config: config}, _) do
    [{"~/.config/nvim/init.lua", config}]
  end
end
