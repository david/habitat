defmodule Habitat.Modules.Lazygit do
  use Habitat.Module

  def pre_sync(container, _) do
    install(container, "lazygit")
  end
end
