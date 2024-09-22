defmodule Habitat.FileBuilder do
  def update(nil, {_, body}) when is_binary(body) do
    {:string, body}
  end

  def update({nil, slots}, {_, body}) when is_binary(body) do
    {:string, EEx.eval_string(body, assigns: merge_slots(slots))}
  end

  def update(nil, {_, slots}) when is_list(slots), do: {nil, slots}
  def update({nil, old_slots}, {_, slots}) when is_list(slots), do: {nil, old_slots ++ slots}

  defp merge_slots(lst) do
    lst
    |> Keyword.keys()
    |> Enum.uniq()
    |> Enum.map(fn k -> {k, lst |> Keyword.get_values(k) |> Enum.join("\n")} end)
    |> Map.new()
  end
end
