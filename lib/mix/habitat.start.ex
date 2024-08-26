defmodule Mix.Tasks.Habitat.Start do
  def run(_) do
    [{_, mod} | _] = Code.require_file("blueprint.exs")
  end
end
