defmodule Habitat.OS.Tumbleweed do
  alias Habitat.PackageManager.Zypper

  def image, do: "tumbleweed"

  def install(container, packages) do
    Zypper.install(container, packages)
  end

  def post_create(container) do
    Zypper.install(container, "which", force: true)
  end
end
