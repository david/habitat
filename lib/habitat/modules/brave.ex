defmodule Habitat.Modules.Brave do
  use Habitat.Module

  def packages(_, _) do
    [
      {
        :apt,
        "brave-browser",
        repo: "https://brave-browser-apt-release.s3.brave.com",
        distribution: "stable",
        component1: "main",
        key: "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
      }
    ]
  end

  def exports do
    ["brave-browser"]
  end
end
