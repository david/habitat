defmodule Habitat.Traits.Export do
  require Logger

  alias Habitat.Container

  def post_install(container) do
    for exp <- container.exports do
      Logger.info("Exporting #{exp}")

      Container.cmd(container, ["distrobox-export", "--delete", "--app", exp])

      {_, 0} = Container.cmd(container, ["distrobox-export", "--app", exp])
    end
  end
end
