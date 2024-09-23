defmodule Habitat.Modules.Git do
  use Habitat.Module

  def packages(_, _) do
    ["git"]
  end
end
