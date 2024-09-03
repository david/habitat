defmodule Habitat.Modules.Fish do
  use Habitat.Module

  def pre_sync(container_id, _, %{editing_mode: mode}) do
    install(container_id, "fish")

    editing =
      case mode do
        :vi ->
          """
          set fish_cursor_default block
          set fish_cursor_insert line

          if [ $TERM_PROGRAM = "WezTerm" ]
            set fish_vi_force_cursor 1
          end

          fish_vi_key_bindings
          """

        _ ->
          ""
      end

    insert(
      container_id,
      "~/.config/fish/config.fish",
      """
      <%= profile %>

      if status is-interactive
        #{editing}

        <%= interactive %>
      end
      """,
      defaults: [profile: "", interactive: ""]
    )
  end
end
