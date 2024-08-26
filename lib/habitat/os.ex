defmodule Habitat.OS do
  def get(key) do
    key
    |> to_string()
    |> Macro.camelize()
    |> then(&Module.concat("Habitat.OS", &1))
  end
end
