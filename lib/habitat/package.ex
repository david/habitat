defmodule Habitat.Package do
  use Ecto.Schema
  import Ecto.Changeset

  schema "packages" do
    field(:name, :string)
    field(:version, :string)
  end

  def new({name, version}) do
    %__MODULE__{name: name, version: version}
  end

  def changeset(package, params \\ %{}) do
    package
    |> cast(params, [:name, :version])
    |> unique_constraint([:name, :version])
  end

  def names(packages) do
    Enum.map(packages, &Map.get(&1, :name))
  end
end
