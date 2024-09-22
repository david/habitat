defmodule Habitat.OS.Ubuntu do
  alias Habitat.PackageManager.{Apt, Brew}

  def sync(manifest, _, _), do: manifest

  def image(version \\ "latest"), do: "ghcr.io/david/habitat-ubuntu:#{version}"

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
