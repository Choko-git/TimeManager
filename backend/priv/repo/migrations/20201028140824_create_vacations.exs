defmodule Backend.Repo.Migrations.CreateVacations do
  use Ecto.Migration

  def change do
    create table(:vacations) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :accepted, :boolean, default: false, null: false
      add :seen, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

  end
end
