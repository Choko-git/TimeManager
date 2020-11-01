defmodule Backend.Repo.Migrations.CreateBelongs do
  use Ecto.Migration

  def change do
    create table(:belongs, primary_key: true) do
      add :team_id, references(:teams, on_delete: :nothing), primary_key: false
      add :user_id, references(:users, on_delete: :nothing), primary_key: false

      timestamps()
    end

    create index(:belongs, [:team_id])
    create index(:belongs, [:user_id])
  end
end
