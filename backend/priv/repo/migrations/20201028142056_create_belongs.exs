defmodule Backend.Repo.Migrations.CreateBelongs do
  use Ecto.Migration

  def change do
    create table(:belongs) do
      add :teams_id, references(:teams, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:belongs, [:teams_id])
    create index(:belongs, [:user_id])
  end
end
