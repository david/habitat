defmodule Habitat.Modules.GitDelta do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring git-delta")

    install(container, "git-delta")
  end
end
