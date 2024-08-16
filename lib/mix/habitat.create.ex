defmodule Mix.Tasks.Habitat.Create do
  @shortdoc "Create missing containers"

  use Mix.Task
  import Mix.Habitat
  alias Habitat.Container

  @impl true
  def run(args) do
    {out, 0} = System.cmd("distrobox-host-exec", ["distrobox", "list", "--no-color"])

    created =
      out
      |> String.trim()
      |> String.split("\n")
      |> tl()
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(fn [_id, name | _rest] -> String.trim(name) end)

    blueprint().containers()
    |> Enum.filter(fn c -> Enum.empty?(args) || c.name in args end)
    |> tap(&Enum.each(&1, fn c -> File.mkdir_p!(c.root) end))
    |> Enum.filter(&(&1.name not in created))
    |> Enum.each(&Container.create/1)
  end
end
