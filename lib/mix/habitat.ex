defmodule Mix.Habitat do
  def blueprint do
    "blueprint.exs"
    |> Code.require_file()
    |> List.first()
    |> elem(0)
  end
end
