defmodule Habitat.Modules.Fish do
  use Habitat.Module

  def packages(_, _) do
    ["fish"]
  end

  def files(_, blueprint) do
    editing = blueprint |> get_in([:editing, :style]) |> editing_mode()

    [
      {
        "~/.config/fish/config.fish",
        {
          """
          <%= @env %>

          fish_add_path --prepend --path ~/.local/bin

          if status is-interactive
            set -U fish_greeting ""

            #{editing}

            <%= @init %>
          end
          """,
          env: "", init: ""
        }
      }
    ]
  end

  defp editing_mode(:vi) do
    """
    set fish_cursor_default block
    set fish_cursor_insert line

    fish_vi_key_bindings
    """
  end

  defp editing_mode(:emacs), do: ""
  defp editing_mode(nil), do: ""

  defp editing_mode(mode) do
    raise "Unknown editing mode: #{inspect(mode)}"
  end
end
