defmodule Dievergolderei.BlogTest do
  use Dievergolderei.DataCase

  alias Dievergolderei.Blog

  describe "posts" do
    alias Dievergolderei.Blog.Post

    @valid_attrs %{
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

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post()

      post
      |> Dievergolderei.Repo.preload(:photo)
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "list_most_recent_published_posts/0 returns three most recent posts in descending order" do
      posts = [post_fixture(publish_on: ~D[2019-09-01])]
      posts = [post_fixture(publish_on: ~D[2019-09-02]) | posts]
      posts = [post_fixture(publish_on: ~D[2019-09-03]) | posts]

      assert Blog.list_most_recent_published_posts() == posts
    end

    test "list_most_recent_published_posts/1 returns n most recent posts in descending order" do
      posts = [post_fixture(publish_on: ~D[2019-09-01])]
      posts = [post_fixture(publish_on: ~D[2019-09-02]) | posts]
      posts = [post_fixture(publish_on: ~D[2019-09-03]) | posts]

      assert Blog.list_most_recent_published_posts(2) == Enum.take(posts, 2)
    end

    test "statistics/0 returns date of most recent post and total count of published posts" do
      post = post_fixture()

      assert Blog.statistics()[:latest] == post.publish_on
      assert Blog.statistics()[:count] == 1
    end

    test "list_posts_published_in_month/2 returns all posts for a month/year" do
      may_posts = [
        post_fixture(publish_on: ~D[2018-05-15]),
        post_fixture(publish_on: ~D[2018-05-05])
      ]

      post_fixture(publish_on: ~D[2018-06-05])

      assert Blog.list_posts_published_in_month(05, 2018) == may_posts
    end

    test "months_with_posts/0 returns a list of months where at least one post was published" do
      post_fixture(publish_on: ~D[2018-05-05])
      post_fixture(publish_on: ~D[2018-06-05])

      assert Blog.months_with_posts() == [~D[2018-06-01], ~D[2018-05-01]]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Blog.create_post(@valid_attrs)
      assert post.content == "some content"
      assert post.publish_on == ~D[2010-04-17]
      assert post.slug == "some slug"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Blog.update_post(post, @update_attrs)
      assert post.content == "some updated content"
      assert post.publish_on == ~D[2011-05-18]
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
