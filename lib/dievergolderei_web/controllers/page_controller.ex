defmodule DievergoldereiWeb.PageController do
  use DievergoldereiWeb, :controller

  alias Dievergolderei.Pages

  def index(conn, _params) do
    hours = Dievergolderei.OpeningHours.list_active_hours()
    posts = Dievergolderei.Blog.list_most_recent_published_posts(3)
    content = Pages.get_content_by_name!("index")
    render(conn, "index.html", static_content: content, hours: hours, posts: posts)
  end

  def contact(conn, _params) do
    content = Pages.get_content_by_name!("contact")
    render(conn, "contact.html", title: "Kontakt — ", static_content: content)
  end

  def gallery(conn, _params) do
    photos = Dievergolderei.Gallery.list_gallery_photos()
    render(conn, "gallery.html", photos: photos, title: "Impressionen — ")
  end

  def history(conn, _params) do
    content = Pages.get_content_by_name!("history")
    render(conn, "history.html", title: "Geschichte — ", static_content: content)
  end

  def admin(conn, _params) do
    post_statistics = Dievergolderei.Blog.statistics()

    render(conn, "admin.html", blog_statistics: post_statistics, title: "Admin — ")
  end
end
