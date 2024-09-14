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

  def toml(content) do
    for {k, v} <- content, into: "" do
      cond do
        is_map(v) ->
          "#{k} = #{toml_map(v)}\n"

        Keyword.keyword?(v) ->
          """
          [#{k}]
          #{toml(v)}
          """

        is_list(v) ->
          "#{k} = #{toml_list(v)}"

        is_binary(v) ->
          "#{k} = \"#{v}\"\n"

        true ->
          "#{k} = #{v}\n"
      end
    end
  end

  defp toml_list(list) do
    "[" <>
      (for v <- list do
         cond do
           is_binary(v) ->
             "\"#{v}\""

           true ->
             to_string(v)
         end
       end
       |> Enum.join(", ")) <>
      "]\n"
  end

  defp toml_map(map) do
    "{" <>
      (for {k, v} <- map do
         cond do
           is_binary(v) ->
             "#{k} = \"#{v}\""

           true ->
             "#{k} = #{v}"
         end
       end
       |> Enum.join(", ")) <>
      "}\n"
  end

  def yaml(content, indent \\ 0) do
    String.duplicate(" ", indent * 2) <>
      for {k, v} <- content, into: "" do
        cond do
          Keyword.keyword?(v) ->
            """
            #{k}:
            #{yaml(v, indent + 1)}
            """

          is_binary(v) ->
            "#{k}: \"#{v}\"\n"

          true ->
            "#{k}: #{v}\n"
        end
      end <> "\n"
  end
end
