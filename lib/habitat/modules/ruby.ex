defmodule Habitat.Modules.Ruby do
  use Habitat.Module

  require Logger

  def pre_sync(container, _) do
    Logger.info("Configuring ruby")

    # install(["rust", "libffi", "libyaml", "openssl", "zlib"])
  end
end
