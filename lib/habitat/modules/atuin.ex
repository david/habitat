defmodule Habitat.Modules.Atuin do
  use Habitat.Module

  def files(%{config: config}, blueprint) do
    [
      {"~/.config/atuin/config.toml", build_config(config, blueprint)},
      shell_init(blueprint)
    ]
  end

  def packages(_, _), do: ["atuin"]

  defp build_config(config, %{editing: editing}) do
    initial_mode =
      case Keyword.get(editing, :initial_mode, :insert) do
        :emacs -> "emacs"
        :insert -> "vim-insert"
        :normal -> "vim-normal"
      end

    cursor_shapes = get_in(editing, [:cursor, :shape])

    config
    |> put_in([:keymap_mode], initial_mode)
    |> put_in(
      [:keymap_cursor],
      for {k, v} <- cursor_shapes, into: %{} do
        {
          case k do
            :emacs -> "emacs"
            :insert -> "vim_insert"
            :normal -> "vim_normal"
          end,
          case v do
            :bar -> "steady-bar"
            :block -> "steady-block"
          end
        }
      end
    )
    |> toml()
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
