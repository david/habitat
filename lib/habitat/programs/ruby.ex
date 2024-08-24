defmodule Habitat.Programs.Ruby do
  alias Habitat.Tasks.{Mise, Packages}
  require Logger

  def pre_sync(container, spec) do
    Logger.info("Configuring ruby")

    container
    |> Packages.put(["rust", "libffi", "libyaml", "openssl", "zlib"])
    |> Mise.put("ruby", spec)
  end
end
