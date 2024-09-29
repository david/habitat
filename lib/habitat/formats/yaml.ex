defmodule Habitat.Formats.YAML do
  def from_code(content, indent \\ 0) do
    indent_str = String.duplicate(" ", indent * 2)

    cond do
      Keyword.keyword?(content) ->
        for {k, v} <- content, into: "" do
          "\n#{indent_str}#{k}: #{from_code(v, indent + 1)}"
        end

      is_binary(content) ->
        "\"#{content}\""

      true ->
        "#{content}"
    end
  end
end
