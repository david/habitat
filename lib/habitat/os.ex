defmodule Habitat.OS do
  def get(key) do
    name
    |> to_string()
    |> Macro.camelize()
    |> then(&Module.concat("Habitat.OS", &1))
  end
end
