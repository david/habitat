defmodule Habitat.Module do
  alias Habitat.Container

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__.Behaviour)
      import unquote(__MODULE__)
    end
  end

  defmodule Behaviour do
    @callback files(map(), map()) :: list()
    @callback packages() :: list()

    @optional_callbacks files: 2, packages: 0
  end

  def load({name, spec}) when is_atom(name), do: {from_atom(name), Map.new(spec)}
  def load(name) when is_atom(name), do: {from_atom(name), %{}}

  defp from_atom(name) do
    mod =
      name
      |> to_string()
      |> Macro.camelize()
      |> then(&Module.concat("Habitat.Modules", &1))

    {:module, _} = Code.ensure_loaded(mod)

    mod
  end

  defdelegate toml(code), to: Habitat.Formats.TOML, as: :from_code
  defdelegate yaml(code, indent \\ 0), to: Habitat.Formats.YAML, as: :from_code
end
