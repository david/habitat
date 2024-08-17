defmodule Habitat.Features.Bash do
  require Logger

  def configure(%{features: %{bash: true}} = container) do
    Logger.info("Configuring bash")

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
          {:text, "source ~/.config/bash/bashrc"} => "~/.bashrc",
          {:text, "source ~/.config/bash/bash_profile"} => "~/.bash_profile"
        }
      )
    )
  end

  defp add_packages(container) do
    update_in(container, [:packages], &["bash" | &1])
  end
end
