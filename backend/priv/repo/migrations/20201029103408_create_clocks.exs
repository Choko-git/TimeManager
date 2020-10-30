defmodule Backend.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :status, :boolean, default: false, null: false
      add :total_time, :float, null: true
      add :start, :naive_datetime, null: false
      add :end, :naive_datetime, null: true
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:clocks, [:user_id])
  end
end
