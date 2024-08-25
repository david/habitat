defmodule Habitat.Modules.StarshipTest do
  use ExUnit.Case

  alias Habitat.Modules.Starship

  doctest Starship

  test "adds the correct package" do
    container =
      Starship.pre_sync(
        %{modules: [:starship], packages: []},
        %{}
      )

    assert "starship" in container.packages
  end

  describe "with bash" do
    test "adds shell config" do
      container =
        Starship.pre_sync(
          %{files: [], modules: [:starship, :bash], packages: []},
          %{}
        )

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(bash.+starship.sh))
        end)

      assert {:string, "eval \"$(starship init bash)\""} == from
    end
  end

  describe "with zsh" do
    test "adds shell config" do
      container =
        Starship.pre_sync(
          %{files: [], modules: [:starship, :zsh], packages: []},
          %{}
        )

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(zsh.+starship.sh))
        end)

      assert {:string, "eval \"$(starship init zsh)\""} == from
    end
  end
end
