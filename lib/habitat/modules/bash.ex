defmodule Habitat.Modules.Bash do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    install(container_id, "bash")

    insert(
      container_id,
      "~/.bash_profile",
      """
      <%= profile %>

      source ~/.bashrc
      """,
      defaults: [profile: ""]
    )

    insert(
      container_id,
      "~/.bashrc",
      """
      [[ $- == *i* ]] || return

      <%= interactive %>
      """,
      defaults: [interactive: ""]
    )
  end
end
