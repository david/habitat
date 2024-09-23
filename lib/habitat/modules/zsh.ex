defmodule Habitat.Modules.Zsh do
  use Habitat.Module

  def packages(_, _) do
    ["zsh"]
  end

  def files(_, _) do
    [
      {
        "~/.zprofile",
        """
        <%= @env %>

        source ~/.zshrc
        """
      },
      {
        "~/.zshrc",
        """
        <%= @interactive %>
        """
      }
    ]
  end
end
