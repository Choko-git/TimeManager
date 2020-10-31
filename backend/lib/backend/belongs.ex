defmodule Backend.Belongs do
  @moduledoc """
  The Belongs context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Belongs.Belong
  alias Backend.Teams.Team
  alias Backend.Users.User

  @doc """
  Returns the list of belongs.

  ## Examples

      iex> list_belongs()
      [%Belong{}, ...]

  """
  def list_belongs do
    Repo.all(Belong)
  end

  @doc """
  Gets a single belong.

  Raises `Ecto.NoResultsError` if the Belong does not exist.

  ## Examples

      iex> get_belong!(123)
      %Belong{}

      iex> get_belong!(456)
      ** (Ecto.NoResultsError)

  """
  def get_belong!(id), do: Repo.get!(Belong, id)

  @doc """
  Creates a belong.

  ## Examples

      iex> create_belong(%{field: value})
      {:ok, %Belong{}}

      iex> create_belong(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_belong(attrs \\ %{}) do
    %Belong{}
    |> Belong.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a belong.

  ## Examples

      iex> update_belong(belong, %{field: new_value})
      {:ok, %Belong{}}

      iex> update_belong(belong, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_belong(%Belong{} = belong, attrs) do
    belong
    |> Belong.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a belong.

  ## Examples

      iex> delete_belong(belong)
      {:ok, %Belong{}}

      iex> delete_belong(belong)
      {:error, %Ecto.Changeset{}}

  """
  def delete_belong(%Belong{} = belong) do
    Repo.delete(belong)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking belong changes.

  ## Examples

      iex> change_belong(belong)
      %Ecto.Changeset{data: %Belong{}}

  """
  def change_belong(%Belong{} = belong, attrs \\ %{}) do
    Belong.changeset(belong, attrs)
  end

  def get_info(params) do

    startDate =
      if params["user_id"] do
        from(belong in Belong,
        where:
          belong.user_id == ^params["user_id"]
      )
      else
        true
      end
    endDate =
      if params["team_id"] do
        dynamic([belong], belong.team_id == ^params["team_id"])
      else
        true
      end
    Belong
    |> where(^startDate)
    |> where(^endDate)
    |> Repo.all()
  end

end
