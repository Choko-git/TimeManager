defmodule Backend.Vacations do
  @moduledoc """
  The Vacations context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Vacations.Vacation

  @doc """
  Returns the list of vacations.

  ## Examples

      iex> list_vacations()
      [%Vacation{}, ...]

  """
  def list_vacations do
    Repo.all(Vacation)
  end

  @doc """
  Gets a single vacation.

  Raises `Ecto.NoResultsError` if the Vacation does not exist.

  ## Examples

      iex> get_vacation!(123)
      %Vacation{}

      iex> get_vacation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vacation!(id), do: Repo.get!(Vacation, id)

  @doc """
  Creates a vacation.

  ## Examples

      iex> create_vacation(%{field: value})
      {:ok, %Vacation{}}

      iex> create_vacation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vacation(attrs \\ %{}) do
    %Vacation{}
    |> Vacation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vacation.

  ## Examples

      iex> update_vacation(vacation, %{field: new_value})
      {:ok, %Vacation{}}

      iex> update_vacation(vacation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vacation(%Vacation{} = vacation, attrs) do
    vacation
    |> Vacation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vacation.

  ## Examples

      iex> delete_vacation(vacation)
      {:ok, %Vacation{}}

      iex> delete_vacation(vacation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vacation(%Vacation{} = vacation) do
    Repo.delete(vacation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vacation changes.

  ## Examples

      iex> change_vacation(vacation)
      %Ecto.Changeset{data: %Vacation{}}

  """
  def change_vacation(%Vacation{} = vacation, attrs \\ %{}) do
    Vacation.changeset(vacation, attrs)
  end

  # Récupère tous les vacations de l'utilisateur
  def get_all_vacations(params) do
    from(vacations in Vacation, where: vacations.user_id == ^params["userID"])
    |> Repo.all()
  end

  def get_one_vacation(params) do
    from(vacations in Vacation,
      where:
        vacations.user_id == ^params["userID"] and vacations.id == ^params["vacationID"]
    )
    |> Repo.one()
  end


end
