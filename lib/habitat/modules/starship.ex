defmodule Habitat.Modules.Starship do
  use Habitat.Module

  def packages(_, _) do
    ["starship"]
  end

  def files(%{config: config}, blueprint) do
    [{"~/.config/starship.toml", toml(config)}, shell_init(blueprint)]
  end

  defp shell_init(%{shell: :bash}) do
    {"~/.bashrc", init: "eval \"$(starship init bash)\""}
  end

  defp shell_init(%{shell: :fish}) do
    {"~/.config/fish/config.fish", init: "starship init fish | source"}
  end

  defp shell_init(%{shell: :zsh}) do
    {"~/.zshrc", init: "eval \"$(starship init zsh)\""}
  end
end
