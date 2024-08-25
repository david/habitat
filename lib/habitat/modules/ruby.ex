defmodule Habitat.Modules.Ruby do
  use Habitat.Module

  def pre_sync(container, _) do
    # install(["rust", "libffi", "libyaml", "openssl", "zlib"])
  end
end
