defmodule Habitat.Xdg do
  use Habitat.Module

  def sync(manifest, spec, _) do
    manifest
    |> add_files(user_dirs(spec))
  end

  defp user_dirs(%{user_dirs: false}) do
    [
      {
        "~/.config/user-dirs.conf",
        """
        enabled=False
        """
      }
    ]
  end

  defp user_dirs(_), do: []
end
