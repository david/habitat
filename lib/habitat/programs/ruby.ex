defmodule Habitat.Programs.Ruby do
  alias Habitat.Packages

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring ruby")

    container
    |> Packages.put(["rust", "libffi", "libyaml", "openssl", "zlib"])
  end
end
