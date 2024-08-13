defmodule HabitatTest do
  use ExUnit.Case
  doctest Habitat

  test "greets the world" do
    assert Habitat.hello() == :world
  end
end
