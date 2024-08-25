defmodule Habitat.Modules.Fzf do
  use Habitat.Module

  def pre_sync(container, _) do
    install(container, "fzf")
  end
end
