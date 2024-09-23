defmodule Habitat.Xdg do
  use Habitat.Module

  def files(spec, _) do
    [
      {
        "~/.config/user-dirs.conf",
        """
        enabled=#{if(Map.get(spec, :user_dirs), do: "True", else: "False")}
        """
      }
    ]
  end

  defp user_dirs(_), do: []
end
