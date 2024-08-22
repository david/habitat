defmodule Habitat.Programs.ZoxideTest do
  use ExUnit.Case

  alias Habitat.Programs.Zoxide

  doctest Zoxide

  test "adds the correct package" do
    container =
      Zoxide.sync(%{
        programs: %{zoxide: true},
        packages: []
      })

    assert "zoxide" in container.packages
  end

  describe "with bash" do
    test "adds shell config" do
      container =
        Zoxide.sync(%{
          files: [],
          programs: %{zoxide: true, bash: true},
          packages: []
        })

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(bash.+zoxide.sh))
        end)

      assert {:text, "eval \"$(zoxide init bash)\""} == from
    end
  end

  describe "with zsh" do
    test "adds shell config" do
      container =
        Zoxide.sync(%{
          files: [],
          programs: %{zoxide: true, zsh: true},
          packages: []
        })

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(zsh.+zoxide.sh))
        end)

      assert {:text, "eval \"$(zoxide init zsh)\""} == from
    end
  end
end
