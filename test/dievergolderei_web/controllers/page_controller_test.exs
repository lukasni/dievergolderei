defmodule DievergoldereiWeb.PageControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Pages

  def fixture(name) do
    {:ok, page} =
      Pages.create_static_page(%{name: name, content: "#{String.capitalize(name)} Page"})

    page
  end

  describe "index" do
    setup [:setup_index]

    test "lists hours", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Öffnungszeiten"
    end

    test "lists index page content", %{conn: conn, page: page} do
      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ page.content
    end
  end

  describe "contact" do
    setup [:setup_contact]

    test "lists contact page content", %{conn: conn, page: page} do
      conn = get(conn, Routes.page_path(conn, :contact))
      assert html_response(conn, 200) =~ page.content
    end
  end

  describe "gallery" do
    test "shows static gallery content", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :gallery))
      assert html_response(conn, 200) =~ "Impressionen"
      assert html_response(conn, 200) =~ "<video"
    end
  end

  describe "history" do
    setup [:setup_history]

    test "lists history page content", %{conn: conn, page: page} do
      conn = get(conn, Routes.page_path(conn, :history))
      assert html_response(conn, 200) =~ page.content
    end
  end

  describe "admin" do
    test "redirects unauthenticated user", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :admin))
      assert html_response(conn, 302)
      assert conn.halted
    end
  end

  def setup_index(_) do
    page = fixture("index")
    {:ok, page: page}
  end

  def setup_contact(_) do
    page = fixture("contact")
    {:ok, page: page}
  end

  def setup_history(_) do
    page = fixture("history")
    {:ok, page: page}
  end
end
