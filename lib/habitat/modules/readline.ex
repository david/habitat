defmodule Habitat.Modules.Readline do
  use Habitat.Module

  def files(_, blueprint) do
    main = """
    $include /etc/inputrc

    #{blueprint |> get_in([:editing, :style]) |> editing_style()}
    """

    [{"~/.inputrc", main}]
  end

  defp editing_style(:vi) do
    """
    set editing-mode vi

    set vi-cmd-mode-string "\\1\\e[2 q\\2"
    set vi-ins-mode-string "\\1\\e[6 q\\2"
    """
  end

  defp editing_style(:emacs) do
    """
    set editing-mode emacs
    """
  end

  defp editing_style(nil), do: ""
end
