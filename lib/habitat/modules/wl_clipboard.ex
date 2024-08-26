defmodule Habitat.Modules.WlClipboard do
  use Habitat.Module

  def pre_sync(container, _, _) do
    install(container, "wl-clipboard")
  end
end
