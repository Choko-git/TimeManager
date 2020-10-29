defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password, :string
      add :right_active, :boolean, default: false, null: false
      add :role_id, references(:roles, on_delete: :nothing)
      add :surpervisor_id, references(:users, on_delete: :delete_all)
      add :role, enum

      timestamps()
    end

    create index(:users, [:role_id])
    create index(:users, [:surpervisor_id])
  end
end
