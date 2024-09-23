defmodule Habitat.Modules.Bash do
  use Habitat.Module

  def packages(_, _) do
    ["bash"]
  end

  def files(_, _) do
    [
      {
        "~/.bash_profile",
        """
        <%= @env %>

        source ~/.bashrc
        """
      },
      {
        "~/.bashrc",
        """
        [[ $- == *i* ]] || return

        <%= @init %>
        """
      }
    ]
  end
end
