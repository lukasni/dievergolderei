defmodule DievergoldereiWeb.UploadHelpers do
  use Phoenix.HTML
  alias DievergoldereiWeb.Router.Helpers, as: Routes

  def upload_img_tag(conn, upload, attributes \\ []) do
    img_tag(Routes.photo_path(conn, :serve, upload), attributes)
  end
end
