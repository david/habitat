defmodule Habitat.Formats.TOML do
  def from_code(content) do
    for {k, v} <- content, into: "" do
      cond do
        is_map(v) ->
          "#{k} = #{to_toml_map(v)}\n"

        Keyword.keyword?(v) ->
          """
          [#{k}]
          #{from_code(v)}
          """

        is_list(v) ->
          "#{k} = #{to_toml_list(v)}"

        is_binary(v) ->
          "#{k} = \"#{v}\"\n"

        true ->
          "#{k} = #{v}\n"
      end
    end
  end

  defp to_toml_list(list) do
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

  defp to_toml_map(map) do
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
end
