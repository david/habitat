defmodule Habitat.Modules.ZoxideTest do
  use ExUnit.Case

  alias Habitat.Modules.Zoxide

  doctest Zoxide

  test "adds the correct package" do
    container =
      Zoxide.pre_sync(
        %{modules: [:zoxide], packages: []},
        %{}
      )

    assert "zoxide" in container.packages
  end

  describe "with bash" do
    test "adds shell config" do
      container =
        Zoxide.pre_sync(
          %{files: [], modules: [:zoxide, :bash], packages: []},
          %{}
        )

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(bash.+zoxide.sh))
        end)

      assert {:string, "eval \"$(zoxide init bash)\""} == from
    end
  end

  describe "with zsh" do
    test "adds shell config" do
      container =
        Zoxide.pre_sync(
          %{files: [], modules: [:zoxide, :zsh], packages: []},
          %{}
        )

      {from, _} =
        Enum.find(container.files, fn {_, to} ->
          String.match?(to, ~r(zsh.+zoxide.sh))
        end)

      assert {:string, "eval \"$(zoxide init zsh)\""} == from
    end
  end
end
