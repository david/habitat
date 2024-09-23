defmodule Habitat.Modules.Atuin do
  use Habitat.Module

  def files(%{config: config}, blueprint) do
    [
      {"~/.config/atuin/config.toml", toml(config)},
      shell_init(blueprint)
    ]
  end

  def packages(_, _), do: ["atuin"]

  defp shell_init(%{shell: :bash}) do
    {"~/.bashrc", init: "eval \"$(atuin init bash)\""}
  end

  defp shell_init(%{shell: :fish}) do
    {"~/.config/fish/config.fish", init: "atuin init fish | source"}
  end

  defp shell_init(%{shell: :zsh}) do
    {"~/.zshrc", init: "eval \"$(atuin init zsh)\""}
  end
end
