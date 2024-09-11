defmodule Habitat.Modules.Bash do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    put_package(container_id, "bash")

    put_file(
      container_id,
      "~/.bash_profile",
      """
      <%= @profile %>

      source ~/.bashrc
      """
    )

    put_file(
      container_id,
      "~/.bashrc",
      """
      [[ $- == *i* ]] || return

      <%= @interactive %>
      """
    )
  end
end
