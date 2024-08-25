defmodule Habitat.Programs.Ripgrep do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring ripgrep")

    Packages.put(container, "ripgrep")
  end
end
