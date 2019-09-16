defmodule DievergoldereiWeb.PageController do
  use DievergoldereiWeb, :controller

  def index(conn, _params) do
    hours = Dievergolderei.OpeningHours.list_active_hours()
    posts = Dievergolderei.Blog.list_posts()
    render(conn, "index.html", hours: hours, posts: posts)
  end

  def contact(conn, _params) do
    render(conn, "contact.html", title: "Kontakt — ")
  end

  def gallery(conn, _params) do
    render(conn, "gallery.html", title: "Impressionen — ")
  end

  def history(conn, _params) do
    render(conn, "history.html", title: "Geschichte — ")
  end

  def blog(conn, _params) do
    render(conn, "blog.html", title: "Blog — ")
  end
end
