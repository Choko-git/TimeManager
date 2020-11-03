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
    many_to_many :teams, Backend.Teams.Team, join_through: "belongs"
    has_many :workingtimes, Backend.WorkingTime.Workingtime
    has_many :clocks, Backend.Clocks.Clock
    has_many :vacations, Backend.Vacations.Vacation
    has_many :employees, Backend.Users.User, foreign_key: :surpervisor_id
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
