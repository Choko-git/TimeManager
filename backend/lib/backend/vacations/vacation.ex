defmodule Backend.Vacations.Vacation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vacations" do
    field :accepted, :boolean, default: false
    field :end, :naive_datetime
    field :seen, :boolean, default: false
    field :start, :naive_datetime
    # field :user_id, :id
    belongs_to :user , Backend.Users.User
    timestamps()
  end

  @doc false
  def changeset(vacation, attrs) do
    vacation
    |> cast(attrs, [:start, :end, :accepted, :seen, :user_id])
    |> validate_required([:start, :end, :user_id])
  end
end
