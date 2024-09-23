defmodule Habitat.Modules.Fzf do
  use Habitat.Module

  def packages(_, _) do
    ["fzf"]
  end
end
