defmodule Habitat.Modules do
  def enabled?(container, mod) do
    container
    |> modules()
    |> Keyword.has_key?(to_module(mod))
  end

  def pre_sync(container) do
    container
    |> modules()
    |> Enum.reduce(container, fn {mod, spec}, c -> mod.pre_sync(c, spec) end)
  end

  def post_sync(container) do
    container
    |> modules()
    |> Enum.filter(fn {mod, _} -> function_exported?(mod, :post_sync, 2) end)
    |> Enum.each(fn {mod, spec} -> mod.post_sync(container, spec) end)
  end

  def to_module(name) do
    name
    |> to_string()
    |> Macro.camelize()
    |> then(&Module.concat("Habitat.Modules", &1))
  end

  defp modules(container) do
    container.modules
    |> Enum.map(&normalize/1)
    |> Enum.uniq()
  end

  defp normalize(name) when is_atom(name), do: {to_module(name), []}
  defp normalize({name, spec}), do: {to_module(name), spec}
end
