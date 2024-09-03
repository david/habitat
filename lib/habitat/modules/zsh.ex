defmodule Habitat.Modules.Zsh do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    install(container_id, "zsh")

    insert(
      container_id,
      "~/.zprofile",
      """
      <%= @profile %>

      source ~/.zshrc
      """
    )

    insert(container_id, "~/.zshrc", """
    <%= @interactive %>
    """)
  end
end
