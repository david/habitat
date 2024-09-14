defmodule Habitat.Modules.Zoxide do
  use Habitat.Module

  def packages do
    ["zoxide"]
  end

  def files(_, blueprint) do
    shell_files(blueprint)
  end

  defp shell_files(%{shell: :bash}) do
    [{"~/.bashrc", init: "eval \"$(zoxide init bash)\""}]
  end

  defp shell_files(%{shell: :fish}) do
    [{"~/.config/fish/config.fish", init: "zoxide init fish | source"}]
  end

  defp shell_files(%{shell: :zsh}) do
    [{"~/.zshrc", init: "eval \"$(zoxide init zsh)\""}]
  end
end
