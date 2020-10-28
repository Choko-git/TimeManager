defmodule Backend.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :status, :boolean, default: false
    field :total_time, :float
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :total_time, :start, :end])
    |> validate_required([:status, :total_time, :start, :end])
  end
end
