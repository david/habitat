defmodule Habitat.Modules.Readline do
  use Habitat.Module

  def pre_sync(container_id, _, blueprint) do
    main =
      """
      $include /etc/inputrc

      #{blueprint |> get_in([:editing, :mode]) |> editing_mode()}
      """

    insert(container_id, "~/.inputrc", main)
  end

  defp editing_mode(:vi) do
    """
    set editing-mode vi
    set vi-cmd-mode-string "\\1\\e[2 q\\2"
    set vi-ins-mode-string "\\1\\e[6 q\\2"
    """
  end

  defp editing_mode(:emacs) do
    """
    set editing-mode emacs
    """
  end

  defp editing_mode(nil), do: ""

  defp editing_mode(mode) do
    raise "Invalid editing mode: #{inspect(mode)}"
  end
end
