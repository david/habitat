defmodule Habitat.Tasks.Exports do
  alias Habitat.Container
  require Logger

  def sync(container) do
    for exp <- container.exports do
      Logger.info("Exporting #{exp}")

      Container.cmd(container, ["distrobox-export", "--delete", "--app", exp])

      {_, 0} = Container.cmd(container, ["distrobox-export", "--app", exp])
    end
  end
end
