defmodule Habitat.Modules.Zsh do
  use Habitat.Module

  def packages do
    ["zsh"]
  end

  def files(_, _) do
    [
      {
        "~/.zprofile",
        """
        <%= @profile %>

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
