defmodule Habitat.Modules.Fish do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    install(container_id, "fish")
    put_string(container_id, "~/.config/fish/config.fish", "")
  end
end
