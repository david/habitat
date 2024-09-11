defmodule Habitat.Modules.WlClipboard do
  use Habitat.Module

  def pre_sync(container, _, _) do
    put_package(container, "wl-clipboard")
  end
end
