defmodule DievergoldereiWeb.GalleryTest do
  use DievergoldereiWeb.ConnCase
  import Phoenix.LiveViewTest

  test "disconnected and connected mount", %{conn: conn} do
    conn = get(conn, "/impressionen")
    assert html_response(conn, 200) =~ "<h2>Impressionen</h2>"

    {:ok, view, html} = live(conn)
  end
end
