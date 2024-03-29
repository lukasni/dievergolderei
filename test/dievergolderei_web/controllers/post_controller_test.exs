defmodule DievergoldereiWeb.PostControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.Blog
  import Dievergolderei.AccountsFixtures

  @create_attrs %{
    content: "some content",
    publish_on: ~D[2010-04-17],
    slug: "some slug",
    title: "some title"
  }
  @update_attrs %{
    content: "some updated content",
    publish_on: ~D[2011-05-18],
    slug: "some updated slug",
    title: "some updated title"
  }
  @invalid_attrs %{content: nil, publish_on: nil, slug: nil, title: nil}

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  setup do
    %{
      user: user_fixture()
    }
  end

  test "requires authentication on all admin actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, ~p"/admin/posts"),
        get(conn, ~p"/admin/posts/new"),
        get(conn, ~p"/admin/posts/#{"123"}"),
        get(conn, ~p"/admin/posts/#{"123"}/edit"),
        put(conn, ~p"/admin/posts/#{"123"}", post: %{}),
        post(conn, ~p"/admin/posts", post: %{}),
        delete(conn, ~p"/admin/posts/#{"123"}")
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    test "lists all posts", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/posts")
      assert html_response(conn, 200) =~ "Blogbeiträge"
    end
  end

  describe "blog" do
    setup [:create_post]

    test "lists posts", %{conn: conn, post: post} do
      conn = get(conn, ~p"/blog")
      assert html_response(conn, 200) =~ post.title
    end

    test "filter posts by month", %{conn: conn, post: post} do
      %{year: year, month: month} = post.publish_on
      conn = get(conn, ~p"/blog/#{"#{year}-#{month}"}")
      assert html_response(conn, 200) =~ post.title
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/posts/new")
      assert html_response(conn, 200) =~ "Neuen Beitrag erstellen"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      create_conn = post(conn, ~p"/admin/posts", post: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == ~p"/admin/posts/#{id}"

      conn = get(conn, ~p"/admin/posts/#{id}")
      assert html_response(conn, 200) =~ "Beitragsvorschau"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)
      conn = post(conn, ~p"/admin/posts", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neuen Beitrag erstellen"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post, user: user} do
      conn = conn |> log_in_user(user)
      conn = get(conn, ~p"/admin/posts/#{post}/edit")
      assert html_response(conn, 200) =~ "Blogbeitrag bearbeiten"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post, user: user} do
      conn = conn |> log_in_user(user)
      update_conn = put(conn, ~p"/admin/posts/#{post}", post: @update_attrs)
      assert redirected_to(update_conn) == ~p"/admin/posts/#{post}"

      conn = get(conn, ~p"/admin/posts/#{post}")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post, user: user} do
      conn = conn |> log_in_user(user)
      conn = put(conn, ~p"/admin/posts/#{post}", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Blogbeitrag bearbeiten"
    end
  end

  describe "delete post" do
    setup [:create_post]

    @tag login_as: "test@example.com"
    test "deletes chosen post", %{conn: conn, post: post, user: user} do
      conn = conn |> log_in_user(user)
      delete_conn = delete(conn, ~p"/admin/posts/#{post}")
      assert redirected_to(delete_conn) == ~p"/admin/posts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/admin/posts/#{post}")
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
