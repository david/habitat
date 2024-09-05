defmodule Habitat.Modules.LuaStylua do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    install(container_id, "StyLua")
  end
end
