defmodule DievergoldereiWeb.GalleryLive do
  use Phoenix.LiveView
  alias DievergoldereiWeb.Router.Helpers, as: Routes
  alias Dievergolderei.Gallery

  def render(assigns) do
    ~L"""
    <h2>Impressionen</h2>
    <div class="row">
      <%= for photo <- @photos do %>
        <div class="column" phx-click="show" phx-value-id="<%= photo.id %>">
          <img src="<%= photo_url(photo, :thumb) %>">
        </div>
      <% end %>
    </div>
    <%= if @selected_photo do %>
    <hr>
    <div class="row">
      <%= if @selected_photo.title || @selected_photo.description do %>
      <div class="column responsive column-33">
        <h3><%= @selected_photo.title %></h3>
        <p><%= @selected_photo.description %></p>
      </div>
      <% end %>
      <div class="column">
        <img src="<%= photo_url(@selected_photo, :big) %>">
      </div>
    <% end %>
    """
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

  defp photo_url(photo, version) do
    Dievergolderei.Photo.url({photo.photo, photo}, version)
  end
end
