defmodule Habitat.Modules.Heroku do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    put_package(container_id, {"heroku", url()})
  end

  defp url() do
    "https://cli-assets.heroku.com/channels/stable/heroku-linux-x64.tar.gz"
  end
end
