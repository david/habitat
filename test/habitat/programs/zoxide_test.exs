defmodule Habitat.Programs.StarshipTest do
  use ExUnit.Case

  alias Habitat.Programs.Starship

  doctest Starship

  test "adds the correct package" do
    container =
      Starship.sync(%{
        programs: %{starship: true},
        packages: []
      })

    assert "starship" in container.packages
  end

  describe "with bash" do
    test "adds shell config" do
      container =
        Starship.sync(%{
          files: [],
          programs: %{starship: true, bash: true},
          packages: []
        })

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(bash.+starship.sh))
        end)

      assert {:text, "eval \"$(starship init bash)\""} == from
    end
  end

  describe "with zsh" do
    test "adds shell config" do
      container =
        Starship.sync(%{
          files: [],
          programs: %{starship: true, zsh: true},
          packages: []
        })

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(zsh.+starship.sh))
        end)

      assert {:text, "eval \"$(starship init zsh)\""} == from
    end
  end
end
