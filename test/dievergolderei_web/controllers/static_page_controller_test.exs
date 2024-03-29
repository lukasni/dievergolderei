defmodule DievergoldereiWeb.StaticPageControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Pages
  import Dievergolderei.AccountsFixtures

  @create_attrs %{content: "some content", name: "some name"}
  @update_attrs %{content: "some updated content", name: "some updated name"}
  @invalid_attrs %{content: nil, name: nil}

  def fixture(:static_page) do
    {:ok, static_page} = Pages.create_static_page(@create_attrs)
    static_page
  end

  setup do
    %{
      user: user_fixture()
    }
  end

  test "requires authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, ~p"/admin/pages"),
        get(conn, ~p"/admin/pages/#{"123"}"),
        get(conn, ~p"/admin/pages/#{"123"}/edit"),
        put(conn, ~p"/admin/pages/#{"123"}", page: %{})
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    test "lists all static_pages", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/pages")
      assert html_response(conn, 200) =~ "Statische Seiteninhalte"
    end
  end

  describe "edit static_page" do
    setup [:create_static_page]

    test "renders form for editing chosen static_page", %{conn: conn, static_page: static_page, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/pages/#{static_page}/edit")
      assert html_response(conn, 200) =~ "Seite bearbeiten"
    end
  end

  describe "update static_page" do
    setup [:create_static_page]

    test "redirects when data is valid", %{conn: conn, static_page: static_page, user: user} do
      conn = conn |> log_in_user(user)
      create_conn =
        put(conn, ~p"/admin/pages/#{static_page}", static_page: @update_attrs)

      assert redirected_to(create_conn) ==
               ~p"/admin/pages/#{static_page}"

      conn = get(conn, ~p"/admin/pages/#{static_page}")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, static_page: static_page, user: user} do
      conn = conn |> log_in_user(user)
      conn =
        put(conn, ~p"/admin/pages/#{static_page}", static_page: @invalid_attrs)

      assert html_response(conn, 200) =~ "Seite bearbeiten"
    end
  end

  defp create_static_page(_) do
    static_page = fixture(:static_page)
    {:ok, static_page: static_page}
  end
end
