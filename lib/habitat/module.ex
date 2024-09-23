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

  def add_file(manifest, {target, content}) do
    add_file(manifest, target, content)
  end

  def add_file(manifest, target, content) do
    Habitat.FileList.update(manifest, target, content)
  end

  def add_files(manifest, files) do
    for {target, content} <- files, reduce: manifest do
      m -> add_file(m, target, content)
    end
  end

  defdelegate toml(code), to: Habitat.Formats.TOML, as: :from_code
  defdelegate yaml(code, indent \\ 0), to: Habitat.Formats.YAML, as: :from_code
end
