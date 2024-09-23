defmodule Habitat.Modules.Heroku do
  use Habitat.Module

  def packages(_, _) do
    [{:brew, "heroku", tap: "heroku/brew"}]
  end
end
