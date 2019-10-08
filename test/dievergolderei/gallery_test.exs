defmodule Dievergolderei.GalleryTest do
  use Dievergolderei.DataCase

  alias Dievergolderei.Gallery
  alias Dievergolderei.Gallery.Photo

  describe "uploads" do
    setup do
      File.mkdir_p(Photo.upload_directory())

      on_exit(fn ->
        File.rm_rf(Photo.upload_directory())
      end)
    end

    @upload %Plug.Upload{
      filename: "image.jpg",
      content_type: MIME.from_path("test/support/data/image.jpg"),
      path: Path.expand("test/support/data/image.jpg")
    }

    @valid_attrs %{
      "photo" => @upload,
      "title" => "some title",
      "description" => "some description",
      "in_gallery" => true
    }

    @update_attrs %{
      "title" => "some updated title",
      "description" => "some updated description",
      "in_gallery" => false
    }

    @invalid_attrs %{"photo" => nil, "title" => nil, "description" => nil, "in_gallery" => nil}

    def photo_fixture(attrs \\ %{}) do
      {:ok, photo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gallery.create_photo()

      photo
    end

    test "can create Upload from Plug.Upload" do
      plug = @upload

      {:ok, upload} = Gallery.create_photo_from_plug_upload(plug)

      assert plug.content_type == upload.content_type
      assert plug.filename == upload.filename
    end

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Gallery.list_photos() == [photo]
    end

    test "list_gallery_photos/1 returns list of n mhoto recent gallery photos" do
      _photo1 = photo_fixture()
      photo2 = photo_fixture()
      _photo3 = photo_fixture(%{"in_gallery" => false})

      assert Gallery.list_gallery_photos(1) == [photo2]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Gallery.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid data creates a photo" do
      assert {:ok, %Photo{} = photo} = Gallery.create_photo(@valid_attrs)
      assert photo.description == "some description"
      assert photo.title == "some title"
      assert photo.in_gallery == true
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gallery.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{} = photo} = Gallery.update_photo(photo, @update_attrs)
      assert photo.description == "some updated description"
      assert photo.title == "some updated title"
      assert photo.in_gallery == false
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Gallery.update_photo(photo, @invalid_attrs)
      assert photo == Gallery.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      path = Photo.local_path(photo)
      assert {:ok, %Photo{}} = Gallery.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Gallery.get_photo!(photo.id) end
      assert_raise File.Error, fn -> File.read!(path) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Gallery.change_photo(photo)
    end
  end
end
