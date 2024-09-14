defmodule Habitat.Modules.Wezterm do
  use Habitat.Module

  # @version "20240203-110809-5046fc22"
  # @url "https://github.com/wez/wezterm/releases/download/#{@version}/wezterm-#{@version}.Ubuntu22.04.tar.xz"
  #
  # def pre_sync(container, opts, _) do
  #   container
  #   |> put_package("wezterm",
  #     download: %{
  #       url: @url,
  #     },
  #   )
  #   # |> put_path("~/.config/wezterm", config)
  #
  #   # if Keyword.get(opts, :export) do
  #   #   export(container_id, "wezterm")
  #   # end
  # end
end
