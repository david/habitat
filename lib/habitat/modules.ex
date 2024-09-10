defmodule Habitat.Modules do
  def pre_sync(id, blueprint) do
    blueprint
    |> modules()
    |> Enum.each(fn {mod, spec} -> mod.pre_sync(id, spec, blueprint) end)
  end

  def post_sync(id) do
    id
    |> modules()
    |> Enum.filter(fn {mod, _} -> function_exported?(mod, :post_sync, 2) end)
    |> Enum.each(fn {mod, spec} -> mod.post_sync(id, spec) end)
  end

  def to_module(name) do
    name
    |> to_string()
    |> Macro.camelize()
    |> then(&Module.concat("Habitat.Modules", &1))
  end

  defp modules(spec) do
    spec.modules
    |> Enum.map(&normalize/1)
    |> Enum.uniq()
  end

  defp normalize(name) when is_atom(name), do: {to_module(name), []}
  defp normalize({name, spec}), do: {to_module(name), spec}
end
