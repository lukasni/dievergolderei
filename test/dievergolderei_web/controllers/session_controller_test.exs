defmodule DievergoldereiWeb.SessionControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Accounts.User

  @create_attrs %{email: "test@example.com", password: "supersecret", display_name: "Test User"}

  defp create_user(_) do
    user = user_fixture(@create_attrs)
    {:ok, user: user}
  end

  describe "login page" do
    test "shows login form", %{conn: conn} do
      conn = get(conn, ~p"/sessions/new")
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "existing user" do
    setup [:create_user]

    test "redirects with correct password", %{conn: conn, user: user} do
      conn = post(conn, ~p"/sessions", session: @create_attrs)

      assert redirected_to(conn) == ~p"/admin"
      assert %User{} = conn.assigns[:current_user]

      conn = get(conn, ~p"/admin")
      assert html_response(conn, 200) =~ "Adminbereich"
    end

    test "rejects incorrect password", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/sessions", session: %{email: user.email, password: "incorrect"})

      assert nil == conn.assigns[:current_user]
      assert html_response(conn, 200) =~ "Invalid username/password combination"

      conn = get(conn, ~p"/admin")
      assert redirected_to(conn) == ~p"/sessions/new"
    end
  end

  describe "logged in user" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "user can log out", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/sessions/#{user}")

      assert nil == conn.assigns[:current_user]
      assert redirected_to(conn) == ~p"/"
    end
  end
end

"""
create_conn = post(conn, ~p"/admin/hours", hours: @create_attrs)

assert redirected_to(create_conn) == ~p"/admin/hours"

conn = get(conn, ~p"/admin/hours")
assert html_response(conn, 200) =~ "some label"
"""
