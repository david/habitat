defmodule Habitat.Resource do
  require Logger

  def merge(nil, body) when is_binary(body), do: normalize(body)
  def merge(nil, variables) when is_list(variables), do: normalize(variables)
  def merge(nil, {:link, path}), do: {:link, path}
  def merge(nil, {template, variables}), do: normalize({template, variables})

  def merge({:string, _, variables}, body) when is_binary(body) do
    normalize({body, variables})
  end

  def merge({:string, body, old_vars}, new_vars) when is_list(new_vars) do
    normalize({body, old_vars ++ new_vars})
  end

  def merge({:string, _, variables}, {template, defaults}) do
    normalize({template, defaults ++ variables})
  end

  def normalize({:link, path}), do: {:link, path}
  def normalize(body) when is_binary(body), do: {:string, body}
  def normalize(variables) when is_list(variables), do: {:string, nil, variables}
  def normalize({template, variables}), do: {:string, template, variables}

  def prepare({:link, path}), do: {:link, path}
  def prepare({:string, content}), do: {:string, content}

  def prepare({:string, template, variables}) do
    Logger.debug("Bulding file from template")
    Logger.debug(inspect(template))
    Logger.debug(inspect(variables))

    merged_vars =
      variables
      |> Keyword.keys()
      |> Enum.uniq()
      |> Enum.map(fn k -> {k, variables |> Keyword.get_values(k) |> Enum.join("\n")} end)
      |> Map.new()

    {:string, EEx.eval_string(template, assigns: merged_vars)}
  end
end
