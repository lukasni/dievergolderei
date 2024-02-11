defmodule Dievergolderei.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Dievergolderei.Repo

  alias Dievergolderei.Accounts.User

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

  def get_user(id), do: Repo.get(User, id)

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
  Deletes a User.

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
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Gets an user by email if the provided password is correct

      iex> authenticate_user_by_email_and_password("correct@email.com", "correctpassword")
      {:ok, %User{}}

      iex> authenticate_user_by_email_and_password("correct@email.com", "incorrect")
      {:error, "invalid password"}

      iex> authenticate_by_email_and_password("wrong@email.com", "irrelevant")
      {:error, "invalid user-identifier"}
  """
  def authenticate_by_email_and_password(email, password) do
    User
    |> where(email: ^email)
    |> Repo.one()
    |> User.check_pass(password)
  end

  def generate_admin_user do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
    length = 12

    user = %{
      display_name: "Admin",
      email: "admin@local",
      password: (for _ <- 1..length, into: "", do: << Enum.random(alphabet) >>)
    }

    IO.puts("""
    Created new admin user:
    #{inspect user}
    """)

    create_user(user)
  end
end
