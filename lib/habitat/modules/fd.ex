defmodule Habitat.Modules.Fd do
  use Habitat.Module

  alias Habitat.PackageManager.Brew

  def pre_sync(container, _, _) do
    install(container, "fd", provider: Brew)
  end
end
