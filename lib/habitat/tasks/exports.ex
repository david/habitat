defmodule Habitat.Tasks.Exports do
  alias Habitat.Container
  require Logger

  def sync(curr, prev) do
    to_unexport = prev.exports -- curr.exports
    Logger.info("Unexporting #{inspect(to_unexport)}")

    for unexp <- to_unexport do
      Container.cmd(curr, ["distrobox-export", "--delete", "--app", unexp])
    end

    to_export = curr.exports -- prev.exports
    Logger.info("Exporting #{inspect(to_export)}")

    for exp <- to_export do
      {_, 0} = Container.cmd(curr, ["distrobox-export", "--app", exp])
    end
  end
end
