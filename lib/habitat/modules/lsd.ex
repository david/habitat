defmodule Habitat.Modules.Lsd do
  use Habitat.Module

  @aliases """
  alias ls=lsd
  alias ll="lsd -l"
  alias la="lsd -a"
  alias lla="lsd -la"
  """

  def packages do
    ["lsd"]
  end

  def files(%{config: config}, blueprint) do
    [{"~/.config/lsd/config.yml", yaml(config)}] ++ shell_aliases(blueprint)
  end

  defp shell_aliases(%{shell: :bash}) do
    [{"~/.bashrc", init: @aliases}]
  end

  defp shell_aliases(%{shell: :fish}) do
    [{"~/.config/fish/config.fish", init: @aliases}]
  end

  defp shell_aliases(%{shell: :zsh}) do
    [{"~/.zshrc", init: @aliases}]
  end
end
