defmodule DievergoldereiWeb.PageControllerTest do
  use DievergoldereiWeb.ConnCase

  import Dievergolderei.PageFixtures
  import Dievergolderei.AccountsFixtures

  setup do
    %{
      pages: page_fixtures(),
      user: user_fixture()
    }
  end

  describe "index page" do
    test "lists hours", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "Öffnungszeiten"
    end

    test "lists index & featured page content", %{conn: conn, pages: pages} do
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ pages[:index].content
      assert response =~ pages[:featured].content
    end
  end

  describe "contact page" do
    test "lists contact page content", %{conn: conn, pages: pages} do
      conn = get(conn, ~p"/kontakt")
      response = html_response(conn, 200)
      assert response =~ pages[:contact].content
    end
  end

  describe "gallery page" do
    test "shows static gallery content", %{conn: conn} do
      conn = get(conn, ~p"/impressionen")
      response = html_response(conn, 200)
      assert response =~ "Impressionen"
      assert response =~ "<video"
    end
  end

  describe "history page" do
    test "lists history page content", %{conn: conn, pages: pages} do
      conn = get(conn, ~p"/geschichte")
      response = html_response(conn, 200)
      assert response =~ pages[:history].content
    end
  end

  describe "admin page" do
    test "redirects unauthenticated user", %{conn: conn} do
      conn = get(conn, ~p"/admin")
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "allows authenticated user", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/admin")
      response = html_response(conn, 200)
      assert response =~ "Adminübersicht"
    end

    test "contains links to subadmin pages", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/admin")
      response = html_response(conn, 200)

      assert response =~ ~p"/admin/posts"
      assert response =~ ~p"/admin/hours"
      assert response =~ ~p"/admin/photos"
      assert response =~ ~p"/admin/shop"
      assert response =~ ~p"/admin/pages"
      assert response =~ ~p"/admin/users"
      assert response =~ ~p"/admin/dashboard"
    end
  end
end
