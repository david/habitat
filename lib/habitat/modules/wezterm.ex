defmodule Habitat.Modules.Wezterm do
  use Habitat.Module

  alias Habitat.Exports

  def pre_sync(container, opts) do
    install(container, "wezterm")

    if Keyword.get(opts, :export) do
      Exports.put(container, "wezterm")
    else
      container
    end
  end
end
