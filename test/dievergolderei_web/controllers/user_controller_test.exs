defmodule DievergoldereiWeb.UserControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Accounts

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
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/admin/users")
      assert html_response(conn, 200) =~ "test@example.com"
    end
  end

  describe "new user" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/admin/users/new")
      assert html_response(conn, 200) =~ "Neuer Benutzer"
    end
  end

  describe "create user" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "redirects to show when data is valid", %{conn: conn} do
      create_conn = post(conn, ~p"/admin/users", user: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == ~p"/admin/users/#{id}"

      conn = get(conn, ~p"/admin/users/#{id}")
      assert html_response(conn, 200) =~ "Show User"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/admin/users", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neuer Benutzer"
    end
  end

  describe "edit user" do
    setup [:create_user, :login_user]

    @tag login_as: "test@example.com"
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/admin/users/#{user}/edit")
      assert html_response(conn, 200) =~ "Benutzer bearbeiten"
    end
  end

  describe "update user" do
    setup [:create_user, :login_user]

    @tag login_as: "test@example.com"
    test "redirects when data is valid", %{conn: conn, user: user} do
      update_conn = put(conn, ~p"/admin/users/#{user}", user: @update_attrs)
      assert redirected_to(update_conn) == ~p"/admin/users/#{user}"

      conn = get(conn, ~p"/admin/users/#{user}")
      assert html_response(conn, 200) =~ "some updated display_name"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/admin/users/#{user}", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Benutzer bearbeiten"
    end
  end

  describe "delete user" do
    setup [:create_user, :login_user]

    @tag login_as: "test@example.com"
    test "deletes chosen user", %{conn: conn, user: user} do
      delete_conn = delete(conn, ~p"/admin/users/#{user}")
      assert redirected_to(delete_conn) == ~p"/admin/users"

      assert_error_sent 404, fn ->
        get(conn, ~p"/admin/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
