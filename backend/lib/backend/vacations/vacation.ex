defmodule Backend.Vacations.Vacation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vacations" do
    field :accepted, :boolean, default: false
    field :end, :naive_datetime
    field :seen, :boolean, default: false
    field :start, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(vacation, attrs) do
    vacation
    |> cast(attrs, [:start, :end, :accepted, :seen])
    |> validate_required([:start, :end, :accepted, :seen])
  end
end
