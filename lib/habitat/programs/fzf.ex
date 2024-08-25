defmodule Habitat.Programs.Fzf do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring fzf")

    Packages.put(container, "fzf")
  end
end
