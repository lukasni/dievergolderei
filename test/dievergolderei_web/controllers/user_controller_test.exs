defmodule DievergoldereiWeb.UserControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Accounts
  import Dievergolderei.AccountsFixtures

  @create_attrs %{
    display_name: "some display_name",
    email: "email@example.com",
    password: "some password"
  }
  @update_attrs %{
    display_name: "some updated display_name",
    email: "newemail@example.com",
    password: "some updated password"
  }
  @invalid_attrs %{display_name: nil, email: nil, password_hash: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup do
    %{
      user: user_fixture()
    }
  end

  test "requires authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, ~p"/admin/photos"),
        get(conn, ~p"/admin/photos/new"),
        get(conn, ~p"/admin/photos/#{"123"}"),
        get(conn, ~p"/admin/photos/#{"123"}/edit"),
        put(conn, ~p"/admin/photos/#{"123"}", user: %{}),
        post(conn, ~p"/admin/users", user: %{}),
        delete(conn, ~p"/admin/users/#{"123"}")
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    test "lists all users", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/users")
      assert html_response(conn, 200) =~ user.email
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/users/new")
      assert html_response(conn, 200) =~ "Neuen Benutzer erstellen"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      create_conn = post(conn, ~p"/admin/users", user: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == ~p"/admin/users/#{id}"

      conn = get(conn, ~p"/admin/users/#{id}")
      assert html_response(conn, 200) =~ "Benutzer"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      conn = post(conn, ~p"/admin/users", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neuen Benutzer erstellen"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, new_user: new_user, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/users/#{new_user}/edit")
      assert html_response(conn, 200) =~ "Benutzer bearbeiten"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, new_user: new_user, user: user} do
      conn = conn |> log_in_user(user)
      update_conn = put(conn, ~p"/admin/users/#{new_user}", user: @update_attrs)
      assert redirected_to(update_conn) == ~p"/admin/users/#{new_user}"

      conn = get(conn, ~p"/admin/users/#{new_user}")
      assert html_response(conn, 200) =~ "some updated display_name"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn, new_user: new_user, user: user} do
      conn = conn |> log_in_user(user)
      conn = put(conn, ~p"/admin/users/#{new_user}", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Benutzer bearbeiten"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, new_user: new_user, user: user} do
      conn = conn |> log_in_user(user)
      delete_conn = delete(conn, ~p"/admin/users/#{new_user}")
      assert redirected_to(delete_conn) == ~p"/admin/users"

      assert_error_sent 404, fn ->
        get(conn, ~p"/admin/users/#{new_user}")
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, new_user: user}
  end
end
