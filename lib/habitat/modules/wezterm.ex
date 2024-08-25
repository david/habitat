defmodule Habitat.Modules.Wezterm do
  alias Habitat.{Exports, Packages}

  require Logger

  def pre_sync(container, opts) do
    Logger.info("Configuring wezterm")

    container = Packages.put(container, "wezterm")

    if Keyword.get(opts, :export) do
      Exports.put(container, "wezterm")
    else
      container
    end
  end
end
