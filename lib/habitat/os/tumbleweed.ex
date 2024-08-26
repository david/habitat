defmodule Habitat.OS.Tumbleweed do
  alias Habitat.Container
  alias Habitat.PackageManager.Zypper

  defdelegate install(container, packages), to: Zypper

  def image, do: "tumbleweed"

  def pre_sync(container_id, _) do
    Container.install(container_id, [
      "elixir",
      "patterns-devel-base-devel_basis",
      "stow",
      "which"
    ])
  end
end
