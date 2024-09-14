defmodule Habitat.FileBuilder do
  def build({body, slots}) do
    IO.inspect([body, slots, merge_slots(slots)])
    {:string, EEx.eval_string(body, assigns: merge_slots(slots))}
  end

  def update(nil, {_, body}) when is_binary(body), do: {body, []}
  def update({_, slots}, {_, body}) when is_binary(body), do: {body, slots}

  def update(nil, {_, slots}) when is_list(slots), do: {nil, slots}
  def update({body, old_slots}, {_, slots}) when is_list(slots), do: {body, old_slots ++ slots}

  defp merge_slots(lst) do
    lst
    |> Keyword.keys()
    |> Enum.uniq()
    |> Enum.map(fn k -> {k, lst |> Keyword.get_values(k) |> Enum.join("\n")} end)
    |> Map.new()
  end
end
