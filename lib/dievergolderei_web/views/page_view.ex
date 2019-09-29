defmodule DievergoldereiWeb.PageView do
  use DievergoldereiWeb, :view

  defp photo_url(photo, version) do
    Dievergolderei.Photo.url({photo.photo, photo}, version)
  end
end
