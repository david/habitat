defmodule Habitat.Module do
  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__.Behaviour)

      import unquote(__MODULE__)
    end
  end

  defmodule Behaviour do
    @callback sync(map(), map(), any()) :: map()
  end

  def add_package(manifest, package) when is_binary(package) or is_tuple(package) do
    add_packages(manifest, [package])
  end

  def add_packages(manifest, packages) when is_list(packages) do
    Habitat.PackageList.update(manifest, packages)
  end

  def add_file(manifest, file) do
    add_files(manifest, [file])
  end

  def add_files(manifest, files) do
    for {path, _} = entry <- files, reduce: manifest do
      m ->
        cpath = Habitat.Blueprint.container_path(manifest.blueprint, path)

        update_in(
          m,
          [:files],
          fn fs -> Map.put(fs, cpath, Habitat.FileBuilder.update(fs[cpath], entry)) end
        )
    end
  end

  defdelegate toml(code), to: Habitat.Formats.TOML, as: :from_code
  defdelegate yaml(code, indent \\ 0), to: Habitat.Formats.YAML, as: :from_code
end
