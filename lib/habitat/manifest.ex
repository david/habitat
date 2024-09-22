defmodule Habitat.Manifest do
  def new(%{id: id, modules: modules, root: root} = blueprint) do
    manifest = %{
      files: %{},
      blueprint: blueprint,
      id: id,
      packages: [],
      root: root
    }

    for {_, mod, spec} <- modules, reduce: manifest do
      m -> mod.sync(m, spec, blueprint)
    end
  end
end
