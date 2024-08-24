defmodule Mix.Habitat do
  def blueprint do
    "blueprint.exs"
    |> Code.eval_file()
    |> elem(0)
    |> elem(1)
  end
end
