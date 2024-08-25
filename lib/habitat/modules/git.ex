defmodule Habitat.Modules.Git do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring git")

    install(container, "git")
  end
end
