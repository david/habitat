defmodule Habitat.Modules.Bat do
  use Habitat.Module

  def pre_sync(container, _) do
    install(container, "bat")
  end
end
