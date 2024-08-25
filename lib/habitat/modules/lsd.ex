defmodule Habitat.Modules.Lsd do
  use Habitat.Module

  def pre_sync(container, _) do
    install(container, "lsd")
  end
end
