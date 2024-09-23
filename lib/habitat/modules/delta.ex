defmodule Habitat.Modules.Delta do
  use Habitat.Module

  def packages(_, _) do
    ["git-delta"]
  end
end
