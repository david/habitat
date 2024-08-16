defmodule Mix.Habitat do
  def blueprint do
    if Code.loaded?(Blueprints) do
      Blueprints
    else
      "lib/blueprints.ex"
      |> Code.require_file()
      |> List.first()
      |> elem(0)
    end
  end
end
