defmodule Habitat.Modules.Bat do
  use Habitat.Module

  def packages(_, _) do
    ["bat"]
  end
end
