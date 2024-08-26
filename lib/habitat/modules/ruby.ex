defmodule Habitat.Modules.Ruby do
  use Habitat.Module

  def pre_sync(container, _, _) do
    # install(["rust", "libffi", "libyaml", "openssl", "zlib"])
    container
  end
end
