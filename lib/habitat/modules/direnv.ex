defmodule Habitat.Modules.Direnv do
  use Habitat.Module

  def files(_, blueprint) do
    [shell_init(blueprint)]
  end

  def packages(_, _), do: ["direnv"]

  defp shell_init(%{shell: :bash}) do
    {"~/.bashrc", init: "eval \"$(direnv hook bash)\""}
  end

  defp shell_init(%{shell: :fish}) do
    {"~/.config/fish/config.fish", init: "direnv hook fish | source"}
  end

  defp shell_init(%{shell: :zsh}) do
    {"~/.zshrc", init: "eval \"$(direnv hook zsh)\""}
  end
end
