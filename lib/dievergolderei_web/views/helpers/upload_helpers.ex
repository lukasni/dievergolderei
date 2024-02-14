defmodule DievergoldereiWeb.UploadHelpers do
  @moduledoc """
  Helper functions for handling Photos in views
  """
  use Phoenix.HTML
  use DievergoldereiWeb, :verified_routes

  def upload_img_tag(_conn, upload, attributes \\ [])

  def upload_img_tag(_conn, %Dievergolderei.Gallery.Photo{} = upload, attributes) do
    img_tag(~p"/uploads/#{upload}", attributes)
  end

  def upload_img_tag(_conn, %Dievergolderei.Shop.Item{} = upload, attributes) do
    img_tag(~p"/uploads/shop/#{upload}", attributes)
  end
end
