defmodule DievergoldereiWeb.PhotoControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Gallery
  import Dievergolderei.AccountsFixtures

  setup do
    File.mkdir_p(Gallery.Photo.upload_directory())

    on_exit(fn ->
      File.rm_rf(Gallery.Photo.upload_directory())
    end)

    %{
      user: user_fixture()
    }
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
        get(conn, ~p"/admin/photos"),
        get(conn, ~p"/admin/photos/new"),
        get(conn, ~p"/admin/photos/#{"123"}"),
        get(conn, ~p"/admin/photos/#{"123"}/edit"),
        put(conn, ~p"/admin/photos/#{123}", photo: %{}),
        post(conn, ~p"/admin/photos", photo: %{}),
        delete(conn, ~p"/admin/photos/#{"123"}")
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    test "lists all photos", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/admin/photos")
      assert html_response(conn, 200) =~ "Gallerie"
    end
  end

  describe "serve photo" do
    setup [:create_photo]

    test "renders existing photo", %{conn: conn, photo: photo} do
      conn = get(conn, ~p"/uploads/#{photo}")
      assert conn.status == 200
    end
  end

  describe "new photo" do
    test "renders form", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/admin/photos/new")
      assert html_response(conn, 200) =~ "Bild hochladen"
    end
  end

  describe "create photo" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      create_conn = conn |> log_in_user(user) |> post(~p"/admin/photos", photo: @create_attrs)
      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == ~p"/admin/photos/#{id}"

      conn = conn |> log_in_user(user) |> get(~p"/admin/photos/#{id}")
      assert html_response(conn, 200) =~ "Bildvorschau"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(~p"/admin/photos", photo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Das Formular enthält Fehler"
    end
  end

  describe "edit photo" do
    setup [:create_photo]

    test "renders form for editing chosen photo", %{conn: conn, photo: photo, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/admin/photos/#{photo}/edit")
      assert html_response(conn, 200) =~ "Bild bearbeiten"
    end
  end

  describe "update photo" do
    setup [:create_photo]

    test "redirects when data is valid", %{conn: conn, photo: photo, user: user} do
      update_conn = conn |> log_in_user(user) |> put(~p"/admin/photos/#{photo}", photo: @update_attrs)
      assert redirected_to(update_conn) == ~p"/admin/photos/#{photo}"

      conn = conn |> log_in_user(user) |> get(~p"/admin/photos/#{photo}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, photo: photo, user: user} do
      conn = conn |> log_in_user(user)
      conn = put(conn, ~p"/admin/photos/#{photo}", photo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Das Formular enthält Fehler"
    end
  end

  describe "delete photo" do
    setup [:create_photo]

    test "deletes chosen photo from DB and Filesystem", %{conn: conn, photo: photo, user: user} do
      conn = conn |> log_in_user(user)
      delete_conn = delete(conn, ~p"/admin/photos/#{photo}")
      assert redirected_to(delete_conn) == ~p"/admin/photos"

      assert_error_sent 404, fn ->
        get(conn, ~p"/admin/photos/#{photo}")
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
