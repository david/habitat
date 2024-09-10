defmodule Habitat.OS.Ubuntu do
  alias Habitat.PackageManager.{Apt, Brew}

  def image(version \\ "latest"), do: "ghcr.io/david/habitat-ubuntu:#{version}"

  def post_create(container_id) do
    nil
  end

  def pre_sync(container_id, _) do
    Brew.pre_sync(container_id)
  end

  def install(container_id, packages) do
    for {pkg, opts} <- packages do
      case Keyword.take(opts, [:key, :repo]) do
        [key, repo] -> Apt.add_repo(container_id, repo, key)
        _ -> nil
      end
    end

    Apt.install(container_id, for({p, _} <- packages, do: p))
  end
end
