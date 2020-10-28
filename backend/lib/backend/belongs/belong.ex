defmodule Backend.Belongs.Belong do
  use Ecto.Schema
  import Ecto.Changeset

  schema "belongs" do
    field :teams_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(belong, attrs) do
    belong
    |> cast(attrs, [])
    |> validate_required([])
  end
end
