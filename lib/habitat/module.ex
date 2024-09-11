defmodule Habitat.Module do
  alias Habitat.Container

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defdelegate insert(container_id, path, content), to: Container

  def put_file(container_id, target, src) do
    insert(container_id, target, File.read!(src))
  end

  def put_path(container_id, target, src) do
    case src do
      {:dir, dir} ->
        for p <- dir |> Path.join("**") |> Path.wildcard(), File.regular?(p) do
          put_file(container_id, Path.join(target, String.replace(p, dir, "")), p)
        end
    end
  end

  def export(container, app) do
    Container.export(container, [app])
  end

  def put_package(container, package, opts \\ []) do
    Container.put_package(container, [{package, opts}])
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
