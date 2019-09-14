defmodule DievergoldereiWeb.PageController do
  use DievergoldereiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end
end
