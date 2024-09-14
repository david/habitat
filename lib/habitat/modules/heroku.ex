defmodule Habitat.Modules.Heroku do
  use Habitat.Module

  # def pre_sync(container, _, blueprint) do
  #   put_package(container, "atuin",
  #     source: %{
  #       provider: :url,
  #       url: "https://cli-assets.heroku.com/channels/stable/heroku-linux-x64.tar.gz",
  #       checksum: "e3716dfb8a68dbf8992c11dbb6cb9be746cf69a32b80075553c94614c7311792"
  #     },
  #     install: %{
  #       "atuin" => "bin/atuin"
  #     },
  #   )
  # end
end
