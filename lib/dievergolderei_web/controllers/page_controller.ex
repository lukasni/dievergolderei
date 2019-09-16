defmodule DievergoldereiWeb.PageController do
  use DievergoldereiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end

  def gallery(conn, _params) do
    render(conn, "gallery.html")
  end

  def history(conn, _params) do
    render(conn, "history.html")
  end

  def blog(conn, _params) do
    render(conn, "blog.html")
  end
end
