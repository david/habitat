defmodule Habitat.Modules.GitDelta do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring git-delta")

    Packages.put(container, "git-delta")
  end
end
