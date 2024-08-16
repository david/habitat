defmodule Habitat.Features.Bash do
  require Logger

  def configure(%{features: %{bash: true}} = container) do
    Logger.info("Configuring container shell")

    container
    |> add_files()
    |> add_packages()
  end

  def configure(container), do: container

  defp add_files(container) do
    update_in(
      container,
      [:files],
      &Map.merge(
        &1,
        %{
          "~/.config/bash/bashrc" => "files/bash/bashrc",
          "~/.config/bash/bash_profile" => "files/bash/bash_profile",
          "~/.bashrc" => {:text, "source ~/.config/bash/bashrc"},
          "~/.bash_profile" => {:text, "source ~/.config/bash/bash_profile"}
        }
      )
    )
  end

  defp add_packages(container) do
    update_in(container, [:packages], &["bash" | &1])
  end
end
