defmodule Habitat.Traits.Export do
  require Logger

  def post_install(container) do
    for exp <- container.exports do
      Logger.info("Exporting #{exp}")

      System.cmd("distrobox-host-exec", [
        "distrobox",
        "enter",
        "--name",
        container.name,
        "--",
        "distrobox-export",
        "--delete",
        "--app",
        exp
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
          exp
        ])
    end
  end
end
