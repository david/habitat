defmodule Habitat.Packages do
  alias Habitat.{Package, Repo}

  def ensure_all(packages) do
    Enum.map(packages, &ensure/1)
  end

  defp ensure(%Package{name: name} = package) do
    if pkg = Repo.get_by(Package, name: name) do
      pkg
    else
      {:ok, pkg} =
        package
        |> Package.changeset()
        |> Repo.insert_or_update()

      pkg
    end
  end
end
