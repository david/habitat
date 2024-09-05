defmodule Habitat.Modules.LuaLanguageServer do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    install(container_id, "lua-language-server")
  end
end
