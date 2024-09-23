defmodule Habitat.Resource do
  def merge(_, body) when is_binary(body), do: {:string, body}
  def merge(nil, variables) when is_list(variables), do: {:string, nil, variables}

  def merge({:string, nil, oldvars}, variables) when is_list(variables) do
    {:string, nil, oldvars ++ variables}
  end

  def merge(nil, {template, defaults}), do: {:string, template, defaults}

  def merge({:string, nil, variables}, {template, defaults}) do
    {:string, template, defaults ++ variables}
  end

  def prepare({:string, content}), do: {:string, content}

  def prepare({:string, template, variables}) do
    merged_vars =
      variables
      |> Keyword.keys()
      |> Enum.uniq()
      |> Enum.map(fn k -> {k, variables |> Keyword.get_values(k) |> Enum.join("\n")} end)
      |> Map.new()

    {:string, EEx.eval_string(template, assigns: merged_vars)}
  end
end
