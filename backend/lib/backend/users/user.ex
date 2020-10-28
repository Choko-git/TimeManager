defmodule Backend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :right_active, :boolean, default: false
    field :username, :string
    field :role_id, :id
    field :surpervisor_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :right_active])
    |> validate_required([:username, :email, :password, :right_active])
  end
end
