defmodule Habitat.Programs.Git do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring git")

    Packages.put(container, "git")
  end
end
