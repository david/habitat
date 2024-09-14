defmodule Habitat.Modules.Starship do
  use Habitat.Module

  def packages do
    ["starship"]
  end

  def files(%{config: config}, blueprint) do
    [{"~/.config/starship.toml", toml(config)}] ++ shell_files(blueprint)
  end

  defp shell_files(%{shell: :bash}) do
    [{"~/.bashrc", init: "eval \"$(starship init bash)\""}]
  end

  defp shell_files(%{shell: :fish}) do
    [{"~/.config/fish/config.fish", init: "starship init fish | source"}]
  end

  defp shell_files(%{shell: :zsh}) do
    [{"~/.zshrc", init: "eval \"$(starship init zsh)\""}]
  end
end
