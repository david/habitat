defmodule Habitat.Modules.Bash do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("bash")
    |> add_files(files())
  end

  defp files do
    [
      {
        "~/.bash_profile",
        """
        <%= @env %>

        source ~/.bashrc
        """
      },
      {
        "~/.bashrc",
        """
        [[ $- == *i* ]] || return

        <%= @init %>
        """
      }
    ]
  end
end
