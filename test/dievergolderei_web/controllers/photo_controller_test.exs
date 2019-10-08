defmodule DievergoldereiWeb.PhotoControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Gallery

  setup do
    File.mkdir_p(Gallery.Photo.upload_directory())

    on_exit(fn ->
      File.rm_rf(Gallery.Photo.upload_directory())
    end)
  end

  @upload %Plug.Upload{
    filename: "image.jpg",
    content_type: "image/jpeg",
    path: "test/support/data/image.jpg"
  }

  @create_attrs %{
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

  def fixture(:photo) do
    {:ok, photo} = Gallery.create_photo(@create_attrs)
    photo
  end

  test "requires authentication on all admin actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.photo_path(conn, :index)),
        get(conn, Routes.photo_path(conn, :new)),
        get(conn, Routes.photo_path(conn, :show, "123")),
        get(conn, Routes.photo_path(conn, :edit, "123")),
        get(conn, Routes.photo_path(conn, :update, "123")),
        get(conn, Routes.photo_path(conn, :create), photo: %{}),
        get(conn, Routes.photo_path(conn, :delete, "123"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "lists all photos", %{conn: conn} do
      conn = get(conn, Routes.photo_path(conn, :index))
      assert html_response(conn, 200) =~ "Gallerie"
    end
  end

  describe "serve photo" do
    setup [:create_photo]

    test "renders existing photo", %{conn: conn, photo: photo} do
      conn = get(conn, Routes.photo_path(conn, :serve, photo))
      assert conn.status == 200
    end
  end

  describe "new photo" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.photo_path(conn, :new))
      assert html_response(conn, 200) =~ "Bild hochladen"
    end
  end

  describe "create photo" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "redirects to show when data is valid", %{conn: conn} do
      create_conn = post(conn, Routes.photo_path(conn, :create), photo: @create_attrs)
      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.photo_path(create_conn, :show, id)

      conn = get(conn, Routes.photo_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Bildvorschau"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.photo_path(conn, :create), photo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Das Formular enthält Fehler"
    end
  end

  describe "edit photo" do
    setup [:login_user, :create_photo]

    @tag login_as: "test@example.com"
    test "renders form for editing chosen photo", %{conn: conn, photo: photo} do
      conn = get(conn, Routes.photo_path(conn, :edit, photo))
      assert html_response(conn, 200) =~ "Bild bearbeiten"
    end
  end

  describe "update photo" do
    setup [:login_user, :create_photo]

    @tag login_as: "test@example.com"
    test "redirects when data is valid", %{conn: conn, photo: photo} do
      update_conn = put(conn, Routes.photo_path(conn, :update, photo), photo: @update_attrs)
      assert redirected_to(update_conn) == Routes.photo_path(update_conn, :show, photo)

      conn = get(conn, Routes.photo_path(conn, :show, photo))
      assert html_response(conn, 200) =~ "some updated description"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn, photo: photo} do
      conn = put(conn, Routes.photo_path(conn, :update, photo), photo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Das Formular enthält Fehler"
    end
  end

  describe "delete photo" do
    setup [:login_user, :create_photo]

    @tag login_as: "test@example.com"
    test "deletes chosen photo from DB and Filesystem", %{conn: conn, photo: photo} do
      delete_conn = delete(conn, Routes.photo_path(conn, :delete, photo))
      assert redirected_to(delete_conn) == Routes.photo_path(delete_conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.photo_path(conn, :show, photo))
      end

      assert_raise File.Error, fn ->
        File.read!(Gallery.Photo.local_path(photo))
      end
    end
  end

  defp create_photo(_) do
    photo = fixture(:photo)
    {:ok, photo: photo}
  end
end
