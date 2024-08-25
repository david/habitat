defmodule Habitat.Modules.AtuinTest do
  use ExUnit.Case

  alias Habitat.Modules.Atuin

  doctest Atuin

  test "adds the correct package" do
    container =
      Atuin.pre_sync(
        %{modules: [:atuin], packages: []},
        %{}
      )

    assert "atuin" in container.packages
  end

  describe "with bash" do
    test "adds shell config" do
      container =
        Atuin.pre_sync(
          %{files: [], modules: [:atuin, :bash], packages: []},
          %{}
        )

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(bash.+atuin.sh))
        end)

      assert {:string, "eval \"$(atuin init bash)\""} == from
    end
  end

  describe "with zsh" do
    test "adds shell config" do
      container =
        Atuin.pre_sync(
          %{files: [], modules: [:atuin, :zsh], packages: []},
          %{}
        )

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(zsh.+atuin.sh))
        end)

      assert {:string, "eval \"$(atuin init zsh)\""} == from
    end
  end
end
