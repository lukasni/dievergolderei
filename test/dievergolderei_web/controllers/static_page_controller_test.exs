defmodule DievergoldereiWeb.StaticPageControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Pages

  @create_attrs %{content: "some content", name: "some name"}
  @update_attrs %{content: "some updated content", name: "some updated name"}
  @invalid_attrs %{content: nil, name: nil}

  def fixture(:static_page) do
    {:ok, static_page} = Pages.create_static_page(@create_attrs)
    static_page
  end

  test "requires authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.static_page_path(conn, :index)),
        get(conn, Routes.static_page_path(conn, :show, "123")),
        get(conn, Routes.static_page_path(conn, :edit, "123")),
        put(conn, Routes.static_page_path(conn, :update, "123"), hours: %{})
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
    test "lists all static_pages", %{conn: conn} do
      conn = get(conn, Routes.static_page_path(conn, :index))
      assert html_response(conn, 200) =~ "Statische Seiteninhalte"
    end
  end

  describe "edit static_page" do
    setup [:create_static_page, :login_user]

    @tag login_as: "test@example.com"
    test "renders form for editing chosen static_page", %{conn: conn, static_page: static_page} do
      conn = get(conn, Routes.static_page_path(conn, :edit, static_page))
      assert html_response(conn, 200) =~ "Seite bearbeiten"
    end
  end

  describe "update static_page" do
    setup [:create_static_page, :login_user]

    @tag login_as: "test@example.com"
    test "redirects when data is valid", %{conn: conn, static_page: static_page} do
      create_conn =
        put(conn, Routes.static_page_path(conn, :update, static_page), static_page: @update_attrs)

      assert redirected_to(create_conn) ==
               Routes.static_page_path(create_conn, :show, static_page)

      conn = get(conn, Routes.static_page_path(conn, :show, static_page))
      assert html_response(conn, 200) =~ "some updated content"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn, static_page: static_page} do
      conn =
        put(conn, Routes.static_page_path(conn, :update, static_page),
          static_page: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Seite bearbeiten"
    end
  end

  defp create_static_page(_) do
    static_page = fixture(:static_page)
    {:ok, static_page: static_page}
  end
end
