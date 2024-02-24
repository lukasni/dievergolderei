defmodule DievergoldereiWeb.ShopController do
  use DievergoldereiWeb, :controller

  alias Dievergolderei.Shop
  alias Dievergolderei.Shop.Item

  def index(conn, _params) do
    items = Shop.list_items()
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Shop.change_item(%Item{})
    render(conn, "new.html", changeset: changeset, title: "Neuer Shopartikel — Admin — ")
  end

  def create(conn, %{"item" => item_params}) do
    case Shop.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Shopartikel erfolgreich erstellt.")
        |> redirect(to: ~p"/admin/shop/#{item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Shop.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def serve(conn, %{"id" => id}) do
    upload = Shop.get_item!(id)

    conn
    |> put_resp_content_type(upload.content_type)
    |> send_file(200, Item.local_path(upload))
  end

  def edit(conn, %{"id" => id}) do
    item = Shop.get_item!(id)
    changeset = Shop.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Shop.get_item!(id)

    case Shop.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Shopartikel erfolgreich angepasst.")
        |> redirect(to: ~p"/admin/shop/#{item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Shop.get_item!(id)
    {:ok, _item} = Shop.delete_item(item)

    conn
    |> put_flash(:info, "Artikel erfolgreich gelöscht.")
    |> redirect(to: ~p"/admin/shop")
  end
end
