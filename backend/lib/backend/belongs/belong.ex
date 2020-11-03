defmodule Backend.Belongs.Belong do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "belongs" do
    field :team_id, :id
    field :user_id, :id
    timestamps()
  end

  @doc false
  def changeset(belong, attrs) do
    belong
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([])
  end
end
