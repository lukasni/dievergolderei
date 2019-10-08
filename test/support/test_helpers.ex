defmodule Dievergolderei.TestHelpers do
  @moduledoc """
  Test helpers for conn cases.

  TODO: Move other generic fixtures like photo in here to reduce copy-pasting in tests
  """
  alias Dievergolderei.Accounts

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        display_name: "Some User",
        email: "email#{System.unique_integer([:positive])}@example.com",
        password: attrs[:password] || "secretpassword"
      })
      |> Accounts.create_user()

    user
  end

  def login_user(%{conn: conn, login_as: email}) do
    user = user_fixture(%{email: email})
    conn = Plug.Conn.assign(conn, :current_user, user)

    {:ok, conn: conn, user: user}
  end
end
