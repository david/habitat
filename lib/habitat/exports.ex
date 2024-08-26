defmodule Habitat.Exports do
  alias Habitat.Container

  require Logger

  def init(container) do
    Map.put(container, :exports, [])
  end

  def put(container, app) do
    update_in(container, [:exports], &(&1 ++ [app]))
  end

  def sync(container) do
    Logger.info("Exporting #{inspect(container.exports)}")

    for exp <- container.exports do
      Container.cmd(container, ["distrobox-export", "--delete", "--app", exp])

      {_, 0} = Container.cmd(container, ["distrobox-export", "--app", exp])
    end
  end
end
