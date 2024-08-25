defmodule Habitat.Modules.Wezterm do
  use Habitat.Module

  alias Habitat.Exports

  require Logger

  def pre_sync(container, opts) do
    Logger.info("Configuring wezterm")

    install(container, "wezterm")

    if Keyword.get(opts, :export) do
      Exports.put(container, "wezterm")
    else
      container
    end
  end
end
