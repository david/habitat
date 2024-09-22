defmodule Habitat.Modules.Ruby do
  use Habitat.Module

  def sync(manifest, version, blueprint) when is_binary(version) do
    sync(manifest, %{version: version}, blueprint)
  end

  def sync(manifest, %{version: version}, _) do
    manifest
    |> add_packages([
      {:apt, "gcc-11"},
      {:apt, "zlib1g-dev"},
      {:brew, "ruby@#{version}"}
    ])
  end
end
