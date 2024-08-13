defmodule Habitat.Snapshot do
  use Ecto.Schema

  schema "snapshots" do
    field(:version, :integer)

    belongs_to(:package, Habitat.Package)
  end
end
