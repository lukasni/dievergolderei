defmodule DievergoldereiWeb.Breadcrumbs do
  @moduledoc """
  Breadcrumb helpers

  Breadcrumbs are defined as nested calls of crumbs/2.

  A first-level breadcrumb, right off the root, would be defined as follows:

      def crumbs(conn, :first) do
        [{"First", url} | crumbs(conn, :root)]
      end

  A second-level breadcrumb off :first can then call the previously defined crumbs/2 clause:

      def crumbs(conn, :second) do
        [{"Second", url} | crumbs(conn, :first)]
      end
  """
  use Phoenix.HTML
  use DievergoldereiWeb, :verified_routes

  # Breadcrumb definitions

  def crumbs(_conn, :root) do
    [{"Admin", ~p"/admin"}]
  end

  def crumbs(conn, :posts) do
    [{"Blog", ~p"/admin/posts"} | crumbs(conn, :root)]
  end

  def crumbs(conn, :shop_items) do
    [{"Shop", ~p"/admin/shop"} | crumbs(conn, :root)]
  end

  def crumbs(conn, :post_new) do
    [{"Neu", ~p"/admin/posts/new"} | crumbs(conn, :posts)]
  end

  def crumbs(conn, :shop_item_new) do
    [{"Neu", ~p"/admin/shop/new"} | crumbs(conn, :shop_items)]
  end

  def crumbs(conn, :hours) do
    [{"Öffnungszeiten", ~p"/admin/hours"} | crumbs(conn, :root)]
  end

  def crumbs(conn, :hours_new) do
    [{"Neu", ~p"/admin/hours/new"} | crumbs(conn, :hours)]
  end

  def crumbs(conn, :photos) do
    [{"Gallerie", ~p"/admin/photos"} | crumbs(conn, :root)]
  end

  def crumbs(conn, :photo_new) do
    [{"Neu", ~p"/admin/photos"} | crumbs(conn, :photos)]
  end

  def crumbs(conn, :static_pages) do
    [{"Statische Seiten", ~p"/admin/pages"} | crumbs(conn, :root)]
  end

  def crumbs(conn, :users) do
    [{"Benutzer", ~p"/admin/users"} | crumbs(conn, :root)]
  end

  def crumbs(conn, :user_new) do
    [{"Neu", ~p"/admin/users"} | crumbs(conn, :users)]
  end

  def crumbs(conn, :post, %Dievergolderei.Blog.Post{} = post) do
    [{post.slug, ~p"/admin/posts/#{post}"} | crumbs(conn, :posts)]
  end

  def crumbs(conn, :post_edit, %Dievergolderei.Blog.Post{} = post) do
    [{"Bearbeiten", ~p"/admin/posts/#{post}/edit"} | crumbs(conn, :post, post)]
  end

  def crumbs(conn, :hours, %Dievergolderei.OpeningHours.Hours{} = hours) do
    [{hours.label, ~p"/admin/hours/#{hours}/edit"} | crumbs(conn, :hours)]
  end

  def crumbs(conn, :photo, %Dievergolderei.Gallery.Photo{} = photo) do
    [{photo.id, ~p"/admin/photos/#{photo}"} | crumbs(conn, :photos)]
  end

  def crumbs(conn, :shop_item, %Dievergolderei.Shop.Item{} = item) do
    [{item.id, ~p"/admin/shop/#{item}"} | crumbs(conn, :shop_items)]
  end

  def crumbs(conn, :user, %Dievergolderei.Accounts.User{} = user) do
    [{user.display_name, ~p"/admin/users/#{user}/edit"} | crumbs(conn, :users)]
  end

  def crumbs(conn, :photo_edit, %Dievergolderei.Gallery.Photo{} = photo) do
    [{"Bearbeiten", ~p"/admin/photos/#{photo}/edit"} | crumbs(conn, :photo, photo)]
  end

  def crumbs(conn, :shop_item_edit, %Dievergolderei.Shop.Item{} = item) do
    [{"Bearbeiten", ~p"/admin/shop/#{item}/edit"} | crumbs(conn, :shop_item, item)]
  end

  def crumbs(conn, :static_page, %Dievergolderei.Pages.StaticPage{} = page) do
    [{page.name, ~p"/admin/pages/#{page}"} | crumbs(conn, :static_pages)]
  end

  def crumbs(conn, :static_page_edit, %Dievergolderei.Pages.StaticPage{} = page) do
    [{"Bearbeiten", ~p"/admin/pages/#{page}/edit"} | crumbs(conn, :static_page, page)]
  end

  # Implementation

  def breadcrumbs(args) do
    content_tag :nav, role: "navigation" do
      content_tag :ul, class: "breadcrumbs" do
        apply(__MODULE__, :crumbs, args)
        |> render()
      end
    end
  end

  defp render([current | tail]) do
    ([render_crumb(current, :current)] ++ Enum.map(tail, &render_crumb/1))
    |> Enum.reverse()
  end

  defp render_crumb({text, _path}, :current) do
    content_tag(:li, do: text)
  end

  defp render_crumb({text, path}) do
    content_tag(:li, do: link(text, to: path))
  end
end
