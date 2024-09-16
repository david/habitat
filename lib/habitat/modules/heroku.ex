defmodule Habitat.Modules.Heroku do
  use Habitat.Module

  def packages do
    [{"heroku", [tap: "heroku/brew"]}]
  end
end
