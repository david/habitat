defmodule Habitat.Modules.Heroku do
  use Habitat.Module

  def sync(manifest, spec, blueprint) do
    manifest
    |> add_package({:brew, "heroku", [tap: "heroku/brew"]})
  end
end
