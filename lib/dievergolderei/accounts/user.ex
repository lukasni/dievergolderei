defmodule Dievergolderei.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @config Application.compile_env(:dievergolderei, __MODULE__, [])

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :display_name, :string
    field :email, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:display_name, :email, :password])
    |> validate_required([:display_name, :email])
    |> unique_constraint(:email)
    |> validate_length(:password, @config[:password_length])
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
        |> delete_change(:password)

      _ ->
        changeset
    end
  end

  def check_pass(nil, _) do
    Argon2.no_user_verify()
    {:error, "invalid user-identifier"}
  end

  def check_pass(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "invalid password"}
    end
  end
end
