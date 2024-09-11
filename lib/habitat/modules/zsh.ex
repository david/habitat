defmodule Habitat.Modules.Zsh do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    put_package(container_id, "zsh")

    put_file(
      container_id,
      "~/.zprofile",
      """
      <%= @profile %>

      source ~/.zshrc
      """
    )

    put_file(container_id, "~/.zshrc", """
    <%= @interactive %>
    """)
  end
end
