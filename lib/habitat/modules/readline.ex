defmodule Habitat.Modules.Readline do
  use Habitat.Module

  def pre_sync(container_id, _, %{editing_mode: mode}) do
    editing =
      case mode do
        :vi ->
          """
          set editing-mode vi
          set vi-cmd-mode-string "\\1\\e[2 q\\2"
          set vi-ins-mode-string "\\1\\e[6 q\\2"
          """

        _ ->
          nil
      end

    main =
      """
      $include /etc/inputrc

      #{editing}
      """

    insert(container_id, "~/.inputrc", main)
  end
end
