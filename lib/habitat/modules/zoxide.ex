defmodule Habitat.Modules.Zoxide do
  use Habitat.Module

  def sync(manifest, _, blueprint) do
    manifest
    |> add_package("zoxide")
    |> add_file(shell_init(blueprint))
  end

  defp shell_init(%{shell: :bash}) do
    {"~/.bashrc", init: "eval \"$(zoxide init bash)\""}
  end

  defp shell_init(%{shell: :fish}) do
    {"~/.config/fish/config.fish", init: "zoxide init fish | source"}
  end

  defp shell_init(%{shell: :zsh}) do
    {"~/.zshrc", init: "eval \"$(zoxide init zsh)\""}
  end
end
