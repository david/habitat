defmodule Habitat.Modules.Atuin do
  use Habitat.Module

  def sync(manifest, spec, blueprint) do
    manifest
    |> add_package("atuin")
    |> add_files(files(spec, blueprint))
  end

  defp files(%{config: config}, blueprint) do
    [{"~/.config/atuin/config.toml", toml(config)}, shell_init(blueprint)]
  end

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
