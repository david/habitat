defmodule Habitat.Repo.Migrations.CreatePackages do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add(:name, :string, null: false)
      add(:version, :string, null: false)
    end

    create(unique_index(:packages, [:name]))
  end
end
