defmodule Backend.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_users_by_params!(params) do
    roleCheck =
      if params["role"] do
        dynamic([user], user.role == ^params["role"])
      else
        true
      end
    gradeCheck =
      if params["surpervisor_id"] do
        dynamic([user], user.surpervisor_id == ^params["surpervisor_id"])
      else
        true
      end
    User
    |> where(^roleCheck)
    |> where(^gradeCheck)
    |> Repo.all()
  end

  def get_users_of_supervisor!(userId) do
    IO.puts("---------------------")
    IO.puts(userId)
    IO.puts("---------------------")
    User
    |> where([surpervisor_id: ^userId])
    |> preload([:teams])
    |> preload([:vacations])
    |> preload([:workingtimes])
    |> preload([:clocks])
    |> preload([:employees])
    |> Repo.all()
  end

   def get_user_with_teams!(id) do
     from(user_team in User,where: user_team.id == ^id["user_id"], preload: [:teams], preload: [:vacations], preload: [:workingtimes])
     |>Repo.one()
   end

   def get_users_with_teams!() do
     from(users_teams in User, preload: [:teams], preload: [:vacations], preload: [:workingtimes])
     |>Repo.all()
   end

  def get_by_email(user) do
    from(u in User,
      where: u.email == ^user["email"],
    )
    |> Repo.one()
  end
end
