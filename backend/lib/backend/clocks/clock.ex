defmodule Backend.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :end, :naive_datetime, null: true
    field :start, :naive_datetime, null: false
    field :status, :boolean, default: false
    field :total_time, :float, null: true
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :total_time, :start, :end, :user_id])
    |> validate_required([:status, :start])
  end

end
