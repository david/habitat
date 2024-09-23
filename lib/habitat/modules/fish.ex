defmodule Habitat.Modules.Fish do
  use Habitat.Module

  def packages(_, _) do
    ["fish"]
  end

  def files(_, blueprint) do
    editing = blueprint |> get_in([:editing, :mode]) |> editing_mode()

    [
      {
        "~/.config/fish/config.fish",
        """
        <%= @profile %>

        if status is-interactive
          #{editing}

          <%= @init %>
        end
        """
      }
    ]
  end

  defp editing_mode(:vi) do
    """
    set fish_cursor_default block
    set fish_cursor_insert line

    if [ $TERM_PROGRAM = "WezTerm" ]
      set fish_vi_force_cursor 1
    end

    fish_vi_key_bindings
    """
  end

  defp editing_mode(:emacs), do: ""
  defp editing_mode(nil), do: ""

  defp editing_mode(mode) do
    raise "Unknown editing mode: #{inspect(mode)}"
  end
end
