defmodule Habitat.Traits.Export do
  require Logger

  def post_install({name, export: true} = spec, container) do
    Logger.info("Exporting #{name}")

    System.cmd("distrobox-host-exec", [
      "distrobox",
      "enter",
      "--name",
      container.name,
      "--",
      "distrobox-export",
      "--delete",
      "--app",
      to_string(name)
    ])

    {_, 0} =
      System.cmd("distrobox-host-exec", [
        "distrobox",
        "enter",
        "--name",
        container.name,
        "--",
        "distrobox-export",
        "--app",
        to_string(name)
      ])

    spec
  end

  def post_install(spec, _container), do: spec
end
