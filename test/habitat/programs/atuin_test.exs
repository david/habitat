defmodule Habitat.Programs.AtuinTest do
  use ExUnit.Case

  alias Habitat.Programs.Atuin

  doctest Atuin

  test "adds the correct package" do
    container =
      Atuin.sync(%{
        programs: %{atuin: true},
        packages: []
      })

    assert "atuin" in container.packages
  end

  describe "with bash" do
    test "adds shell config" do
      container =
        Atuin.sync(%{
          files: [],
          programs: %{atuin: true, bash: true},
          packages: []
        })

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(bash.+atuin.sh))
        end)

      assert {:text, "eval \"$(atuin init bash)\""} == from
    end
  end

  describe "with zsh" do
    test "adds shell config" do
      container =
        Atuin.sync(%{
          files: [],
          programs: %{atuin: true, zsh: true},
          packages: []
        })

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(zsh.+atuin.sh))
        end)

      assert {:text, "eval \"$(atuin init zsh)\""} == from
    end
  end
end
