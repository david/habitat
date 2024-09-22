defmodule Habitat.Modules.Neovim do
  use Habitat.Module

  def sync(manifest, spec, _) do
    manifest
    |> add_package("neovim")
    |> add_files(files(spec))
  end

  defp files(%{config: config}) do
    for file_name <- File.ls!(config) do
      source_path = Path.join(config, file_name)
      target_path = Path.join("~/.config/neovim", file_name)

      [target_path, source_path]
    end
  end
end
