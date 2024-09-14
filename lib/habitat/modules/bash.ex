defmodule Habitat.Modules.Bash do
  use Habitat.Module

  def packages do
    ["bash"]
  end

  def files(_, _) do
    [
      {
        "~/.bash_profile",
        """
        <%= @profile %>

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
