defmodule Habitat.Modules.Wezterm do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package({
      :apt,
      "wezterm",
      repo: "https://apt.fury.io/wez",
      distribution: "'*'",
      component1: "'*'",
      key: "https://apt.fury.io/wez/gpg.key"
    })
  end

  def exports do
    ["wezterm"]
  end
end
