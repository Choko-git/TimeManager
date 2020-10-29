defmodule Backend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :right_active, :boolean, default: false
    field :role, :string, default: "employee"
    field :username, :string
    field :surpervisor_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :right_active, :role, :surpervisor_id])
    |> validate_required([:username, :email, :password, :right_active, :role])
    |> validate_format(:role, ~r/(admin)\b|(manager)\b|(employee)\b/, [message: "Role must be admin or manager or employee"])
  end
end
