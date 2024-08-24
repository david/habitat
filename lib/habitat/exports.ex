defmodule Habitat.Exports do
  alias Habitat.Container

  require Logger

  def init(container) do
    Map.put_new(container, :exports, [])
  end

  def sync(curr) do
    Logger.info("Exporting #{inspect(curr.exports)}")

    for exp <- curr.exports do
      Container.cmd(curr, ["distrobox-export", "--delete", "--app", exp])

      {_, 0} = Container.cmd(curr, ["distrobox-export", "--app", exp])
    end
  end
end
