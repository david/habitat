defmodule Habitat.Modules.Wezterm do
  use Habitat.Module

  def files(%{config: config}, _) do
    [{"~/.config/wezterm/wezterm.lua", config}]
  end

  def packages(_, _) do
    [
      {
        :apt,
        "wezterm",
        repo: "https://apt.fury.io/wez",
        distribution: "'*'",
        component1: "'*'",
        key: "https://apt.fury.io/wez/gpg.key"
      }
    ]
  end

  def exports do
    ["wezterm"]
  end
end
