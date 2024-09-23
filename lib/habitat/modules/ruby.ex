defmodule Habitat.Modules.Ruby do
  use Habitat.Module

  def packages(version, _) when is_binary(version) do
    packages(%{version: version})
  end

  def packages(%{version: version}) do
    [
      {:apt, "gcc-11"},
      {:apt, "zlib1g-dev"},
      {:brew, "ruby@#{version}"}
    ]
  end
end
