defmodule Habitat.Module do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  require Logger

  defmodule Behaviour do
    @callback sync(map(), map(), any()) :: map()
  end

  def get_module(modish, namespace \\ "Habitat.Modules") do
    name = modish |> to_string() |> get_module_name(namespace)

    case Code.ensure_loaded(name) do
      {:module, mod} ->
        # TODO: return tuple
        mod

      {:error, :nofile} ->
        # TODO: no logger, just return tuple
        Logger.error("No module named #{modish}")
    end
  end

  defp get_module_name("Elixir." <> _ = module_name, _), do: String.to_atom(module_name)

  defp get_module_name(name, namespace) do
    name
    |> Macro.camelize()
    |> then(&Module.concat(namespace, &1))
  end

  defdelegate toml(code), to: Habitat.Formats.TOML, as: :from_code
  defdelegate yaml(code, indent \\ 0), to: Habitat.Formats.YAML, as: :from_code
end
