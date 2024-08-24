defmodule Habitat.Programs do
  def enabled?(container, program) do
    container
    |> programs()
    |> Keyword.has_key?(to_module(program))
  end

  def pre_sync(container) do
    container
    |> programs()
    |> Enum.reduce(container, fn {mod, spec}, c -> mod.pre_sync(c, spec) end)
  end

  def post_sync(container) do
    container
    |> programs()
    |> Enum.filter(fn {mod, _} -> function_exported?(mod, :post_sync, 2) end)
    |> Enum.each(fn {mod, spec} -> mod.post_sync(container, spec) end)
  end

  def to_module(name) do
    name
    |> to_string()
    |> Macro.camelize()
    |> then(&Module.concat("Habitat.Programs", &1))
  end

  defp programs(container) do
    container.programs
    |> Enum.map(&normalize/1)
    |> Enum.uniq()
  end

  defp normalize(name) when is_atom(name), do: {to_module(name), []}
  defp normalize({name, spec}), do: {to_module(name), spec}
end
