defmodule Habitat.Modules.Ruby do
  use Habitat.Module

  def packages(version, _) when is_binary(version) do
    packages(%{version: version})
  end

  def packages(%{version: version}) do
    [
      {:apt, "g++-11"},
      {:apt, "gcc-11"},
      # for curb
      {:apt, "libcurl4-openssl-dev"},
      # for mysql
      {:apt, "libzstd-dev"},
      {:apt, "zlib1g-dev"},
      {:brew, "ruby@#{version}"}
    ]
  end
end
