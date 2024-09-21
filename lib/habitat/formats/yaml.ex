defmodule Habitat.Formats.YAML do
  def from_code(content, indent) do
    String.duplicate(" ", indent * 2) <>
      for {k, v} <- content, into: "" do
        cond do
          Keyword.keyword?(v) ->
            """
            #{k}:
            #{from_code(v, indent + 1)}
            """

          is_binary(v) ->
            "#{k}: \"#{v}\"\n"

          true ->
            "#{k}: #{v}\n"
        end
      end <> "\n"
  end
end
