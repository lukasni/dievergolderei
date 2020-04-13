defmodule DievergoldereiWeb.UploadHelpers do
  @moduledoc """
  Helper functions for handling Photos in views
  """
  use Phoenix.HTML
  alias DievergoldereiWeb.Router.Helpers, as: Routes

  def upload_img_tag(conn, upload, attributes \\ [])
  def upload_img_tag(conn, %Dievergolderei.Gallery.Photo{} = upload, attributes) do
    img_tag(Routes.photo_path(conn, :serve, upload), attributes)
  end
  def upload_img_tag(conn, %Dievergolderei.Shop.Item{} = upload, attributes) do
    img_tag(Routes.shop_path(conn, :serve, upload), attributes)
  end
end
