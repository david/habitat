defmodule Habitat.Modules.Fish do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    install(container_id, "fish")

    insert(
      container_id,
      "~/.config/fish/config.fish",
      """
        <%= profile %>
      if status is-interactive
        <%= interactive %>
      end
      """,
      defaults: [profile: "", interactive: ""]
    )
  end
end
