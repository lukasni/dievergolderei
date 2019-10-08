defmodule Dievergolderei.GalleryTest do
  use Dievergolderei.DataCase

  alias Dievergolderei.Gallery
  alias Dievergolderei.Gallery.Photo

  @testfile "test/support/data/image.jpg"

  describe "uploads" do
    setup do
      File.mkdir_p(Photo.upload_directory())

      on_exit(fn ->
        File.rm_rf(Photo.upload_directory())
      end)
    end

    test "can create Upload from Plug.Upload" do
      plug = %Plug.Upload{
        filename: "image.jpg",
        content_type: MIME.from_path(@testfile),
        path: @testfile
      }

      {:ok, upload} = Gallery.create_photo_from_plug_upload(plug)

      assert plug.content_type == upload.content_type
      assert plug.filename == upload.filename
    end
  end
end
