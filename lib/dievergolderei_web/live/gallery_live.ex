defmodule DievergoldereiWeb.GalleryLive do
  use Phoenix.LiveView
  alias Dievergolderei.Gallery

  def render(assigns) do
    DievergoldereiWeb.PageView.render("gallery.html", assigns)
  end

  def mount(_session, socket) do
    socket =
      socket
      |> assign(:photos, Gallery.list_gallery_photos())
      |> assign(:selected_photo, nil)

    {:ok, socket}
  end

  def handle_event("show", %{"id" => id}, socket) do
    photo = Gallery.get_photo!(id)
    {:noreply, assign(socket, :selected_photo, photo)}
  end
end
