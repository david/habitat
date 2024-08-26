defmodule Habitat.Modules.Wezterm do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    install(container_id, "wezterm")

    if config = Keyword.get(opts, :config) do
      put_path(container_id, "~/.config/wezterm", config)
    end

    if Keyword.get(opts, :export) do
      export(container_id, "wezterm")
    end
  end
end
