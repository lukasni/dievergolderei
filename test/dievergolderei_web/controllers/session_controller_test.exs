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
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "existing user" do
    setup [:create_user]

    test "redirects with correct password", %{conn: conn, user: user} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :admin)
      assert %User{} = conn.assigns[:current_user]

      conn = get(conn, Routes.page_path(conn, :admin))
      assert html_response(conn, 200) =~ user.display_name
    end

    test "rejects incorrect password", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          session: %{email: user.email, password: "incorrect"}
        )

      assert nil == conn.assigns[:current_user]
      assert html_response(conn, 200) =~ "Invalid username/password combination"

      conn = get(conn, Routes.page_path(conn, :admin))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "logged in user" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "user can log out", %{conn: conn, user: user} do
      conn = delete(conn, Routes.session_path(conn, :delete, user))

      assert nil == conn.assigns[:current_user]
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end
end

"""
create_conn = post(conn, Routes.hours_path(conn, :create), hours: @create_attrs)

assert redirected_to(create_conn) == Routes.hours_path(create_conn, :index)

conn = get(conn, Routes.hours_path(conn, :index))
assert html_response(conn, 200) =~ "some label"
"""
