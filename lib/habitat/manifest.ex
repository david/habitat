defmodule Habitat.Manifest do
  alias Habitat.{Blueprint, FileBuilder}

  def build(%{id: id, modules: modules, root: root} = blueprint) do
    %{
      id: id,
      root: root,
      files: get_files(modules, blueprint),
      packages: get_packages(modules)
    }
  end

  defp get_packages(modules) do
    for {mod, spec} <- modules, reduce: [] do
      packages ->
        packages ++
          if function_exported?(mod, :packages, 0) do
            mod.packages()
          else
            []
          end
    end
  end

  defp get_files(modules, blueprint) do
    for {mod, spec} <- modules,
        function_exported?(mod, :files, 2),
        entry <- mod.files(spec, blueprint),
        reduce: %{} do
      files ->
        path = Blueprint.container_path(blueprint, elem(entry, 0))

        put_in(
          files,
          [path],
          FileBuilder.update(files[path], entry)
        )
    end
    |> Enum.map(fn {path, content} -> {path, FileBuilder.build(content)} end)
  end
end
