defmodule Habitat.Modules.Neovim do
  use Habitat.Module

  def packages(_, _) do
    ["neovim"]
  end

  def files(%{config: config}, blueprint) do
    [{"~/.config/nvim/init.lua", config}, shell_env(blueprint)]
  end

  defp shell_env(%{editor: :neovim, shell: :bash}) do
    {"~/.bashrc",
     env: """
     export EDITOR=nvim
     export VISUAL=nvim
     """}
  end

  defp shell_env(%{editor: :neovim, shell: :fish}) do
    {"~/.config/fish/config.fish",
     env: """
     set -gx EDITOR nvim
     set -gx VISUAL nvim
     """}
  end

  defp shell_env(%{editor: :neovim, shell: :zsh}) do
    {"~/.zshrc",
     env: """
     export EDITOR=nvim
     export VISUAL=nvim
     """}
  end
end
