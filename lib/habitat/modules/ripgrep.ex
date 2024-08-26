defmodule Habitat.Modules.Ripgrep do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "ripgrep")
  end
end
