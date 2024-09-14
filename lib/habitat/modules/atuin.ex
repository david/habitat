defmodule Habitat.Modules.Atuin do
  use Habitat.Module

  def packages do
    ["atuin"]
  end

  def files(%{config: config}, blueprint) do
    [{"~/.config/atuin/config.toml", toml(config)}] ++ shell_files(blueprint)
  end

  defp shell_files(%{shell: :bash}) do
    [{"~/.bashrc", init: "eval \"$(atuin init bash)\""}]
  end

  defp shell_files(%{shell: :fish}) do
    [{"~/.config/fish/config.fish", init: "atuin init fish | source"}]
  end

  defp shell_files(%{shell: :zsh}) do
    [{"~/.zshrc", init: "eval \"$(atuin init zsh)\""}]
  end
end
