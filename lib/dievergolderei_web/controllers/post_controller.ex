defmodule DievergoldereiWeb.PostController do
  use DievergoldereiWeb, :controller

  alias Dievergolderei.Blog
  alias Dievergolderei.Blog.Post

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.html", posts: posts, title: "Übersicht Blog — Admin — ")
  end

  def blog(conn, _params) do
    posts = Dievergolderei.Blog.list_most_recent_published_posts(5)
    months = Dievergolderei.Blog.months_with_posts()
    render(conn, "blog.html", title: "Blog — ", posts: posts, months: months)
  end

  def list(conn, %{"month" => month}) do
    [y, m] = String.split(month, "-")
    month = String.to_integer(m)
    year = String.to_integer(y)

    posts = Dievergolderei.Blog.list_posts_published_in_month(month, year)
    months = Dievergolderei.Blog.months_with_posts()
    render(conn, "blog.html", title: "Blog — ", posts: posts, months: months)
  end

  def new(conn, _params) do
    changeset = Blog.change_post(%Post{publish_on: Date.utc_today()})
    render(conn, "new.html", changeset: changeset, title: "Neuer Blogeintrag — Admin — ")
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Eintrag erfolgreich erstellt.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, title: "Übersicht Öffnungszeiten — Admin — ")
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    render(conn, "show.html", post: post, title: "#{post.title} — Admin — ")
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    changeset = Blog.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, title: "Blogeintrag bearbeiten — Admin — ")
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Eintrag erfolgreich angepasst.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset, title: "Blogeintrag bearbeiten — Admin — ")
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Eintrag erfolgreich gelöscht.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
