defmodule Habitat.Modules.Neovim do
  use Habitat.Module

  def packages do
    ["neovim"]
  end

  def files(%{config: config}) do
    for file_name <- File.ls!(config) do
      source_path = Path.join(config, file_name)
      target_path = Path.join("~/.config/neovim", file_name)

      [target_path, source_path]
    end
  end
end
