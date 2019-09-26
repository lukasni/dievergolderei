defmodule DievergoldereiWeb.Breadcrumbs do
  use Phoenix.HTML
  import DievergoldereiWeb.Router.Helpers

  # Breadcrumb definitions

  def crumbs(conn, :root) do
    [{"Admin", page_path(conn, :admin)}]
  end

  def crumbs(conn, :posts) do
    [{"Blog", post_path(conn, :index)} | crumbs(conn, :root)]
  end

  def crumbs(conn, :post_new) do
    [{"Neu", post_path(conn, :new)} | crumbs(conn, :posts)]
  end

  def crumbs(conn, :hours) do
    [{"Öffnungszeiten", hours_path(conn, :index)} | crumbs(conn, :root)]
  end

  def crumbs(conn, :hours_new) do
    [{"Neu", hours_path(conn, :new)} | crumbs(conn, :hours)]
  end

  def crumbs(conn, :photos) do
    [{"Gallerie", photo_path(conn, :index)} | crumbs(conn, :root)]
  end

  def crumbs(conn, :photo_new) do
    [{"Neu", photo_path(conn, :index)} | crumbs(conn, :photos)]
  end

  def crumbs(conn, :static_pages) do
    [{"Statische Seiten", static_page_path(conn, :index)} | crumbs(conn, :root)]
  end

  def crumbs(conn, :post, %Dievergolderei.Blog.Post{} = post) do
    [{post.slug, post_path(conn, :show, post)} | crumbs(conn, :posts)]
  end

  def crumbs(conn, :post_edit, %Dievergolderei.Blog.Post{} = post) do
    [{"Bearbeiten", post_path(conn, :edit, post)} | crumbs(conn, :post, post)]
  end

  def crumbs(conn, :hours, %Dievergolderei.OpeningHours.Hours{} = hours) do
    [{hours.label, hours_path(conn, :edit, hours)} | crumbs(conn, :hours)]
  end

  def crumbs(conn, :photo, %Dievergolderei.Gallery.Photo{} = photo) do
    [{photo.id, photo_path(conn, :show, photo)} | crumbs(conn, :photos)]
  end

  def crumbs(conn, :photo_edit, %Dievergolderei.Gallery.Photo{} = photo) do
    [{"Bearbeiten", photo_path(conn, :edit, photo)} | crumbs(conn, :photo, photo)]
  end

  def crumbs(conn, :static_page, %Dievergolderei.Pages.StaticPage{} = page) do
    [{page.name, static_page_path(conn, :show, page)} | crumbs(conn, :static_pages)]
  end

  def crumbs(conn, :static_page_edit, %Dievergolderei.Pages.StaticPage{} = page) do
    [{"Bearbeiten", static_page_path(conn, :edit, page)} | crumbs(conn, :static_page, page)]
  end

  # Implementation

  def breadcrumbs(args) do
    content_tag :div, class: "row" do
      content_tag :nav, role: "navigation" do
        content_tag :ul, class: "breadcrumbs" do
          apply(__MODULE__, :crumbs, args)
          |> render()
        end
      end
    end
  end

  defp render([current | tail]) do
    ([render_crumb(current, :current)] ++ Enum.map(tail, &render_crumb/1))
    |> Enum.reverse()
  end

  defp render_crumb({text, _path}, :current) do
    content_tag :li, do: text
  end

  defp render_crumb({text, path}) do
    content_tag :li, do: link(text, to: path)
  end
end
