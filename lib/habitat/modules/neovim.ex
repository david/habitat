defmodule Habitat.Modules.Neovim do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    put_package(container_id, "neovim", provider: Habitat.PackageManager.Brew)

    if config = Keyword.get(opts, :config) do
      put_path(container_id, "~/.config/nvim", config)
    end
  end
end
