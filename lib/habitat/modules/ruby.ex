defmodule Habitat.Modules.Ruby do
  use Habitat.Module

  # @url "https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.5.tar.gz"
  #
  # def pre_sync(container, _, _) do
  #   container
  #     |> put_package("ruby",
  #     download: %{
  #       archive: "ruby-3.3.5.tar.gz",
  #       url: @url
  #     }
  #   )
  # end
end
