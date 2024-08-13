defmodule Habitat.Snapshots do
  import Ecto.Query

  alias Habitat.{Snapshot, Repo}

  def list_packages(version) do
    from(s in Snapshot,
      join: p in assoc(s, :package),
      select: p,
      where: s.version == ^version
    )
    |> Repo.all()
  end

  def none?() do
    latest() == 0
  end

  def take(packages) do
    version = latest() + 1

    for p <- packages do
      {:ok, _} = Repo.insert(%Snapshot{package: p, version: version})
    end
  end

  defp latest do
    Repo.aggregate(Snapshot, :max, :version) || 0
  end
end
