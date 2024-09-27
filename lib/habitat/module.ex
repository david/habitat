defmodule Habitat.Module do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmodule Behaviour do
    @callback sync(map(), map(), any()) :: map()
  end

  defdelegate toml(code), to: Habitat.Formats.TOML, as: :from_code
  defdelegate yaml(code, indent \\ 0), to: Habitat.Formats.YAML, as: :from_code
end
