defmodule Habitat.OS.Ubuntu do
  alias Habitat.PackageManager.{Apt, Brew}

  def image, do: "ubuntu"

  def post_create(container_id) do
    :ok = Apt.install(container_id, ["build-essential", "git"])
    :ok = Brew.post_create(container_id)
  end

  def pre_sync(container_id, _) do
    Brew.pre_sync(container_id)
  end

  def install(container_id, packages) do
    Brew.install(container_id, packages)
  end
end
