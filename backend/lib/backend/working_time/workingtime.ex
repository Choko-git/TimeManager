defmodule Backend.WorkingTime.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end