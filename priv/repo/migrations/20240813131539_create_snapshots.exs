defmodule Habitat.Repo.Migrations.CreateSnapshots do
  use Ecto.Migration

  def change do
    create table(:snapshots) do
      add(:package_id, references(:packages), null: false)
      add(:version, :integer, null: false)
    end
  end
end
