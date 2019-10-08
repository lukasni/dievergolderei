defmodule DievergoldereiWeb.PhotoController do
  use DievergoldereiWeb, :controller

  alias Dievergolderei.Gallery
  alias Dievergolderei.Gallery.Photo

  def index(conn, _params) do
    photos = Gallery.list_photos()
    render(conn, "index.html", photos: photos)
  end

  def new(conn, _params) do
    changeset = Gallery.change_photo(%Photo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"photo" => photo_params}) do
    case Gallery.create_photo(photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Foto erfolgreich hochgeladen.")
        |> redirect(to: Routes.photo_path(conn, :show, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Gallery.get_photo!(id)
    render(conn, "show.html", photo: photo)
  end

  def serve(conn, %{"id" => id}) do
    upload = Gallery.get_photo!(id)

    conn
    |> put_resp_content_type(upload.content_type)
    |> send_file(200, Photo.local_path(upload))
  end

  def edit(conn, %{"id" => id}) do
    photo = Gallery.get_photo!(id)
    changeset = Gallery.change_photo(photo)
    render(conn, "edit.html", photo: photo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "photo" => photo_params}) do
    photo = Gallery.get_photo!(id)

    case Gallery.update_photo(photo, photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Foto erfolgreich angepasst.")
        |> redirect(to: Routes.photo_path(conn, :show, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", photo: photo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Gallery.get_photo!(id)
    {:ok, _photo} = Gallery.delete_photo(photo)

    conn
    |> put_flash(:info, "Foto erfolgreich gelöscht.")
    |> redirect(to: Routes.photo_path(conn, :index))
  end
end
