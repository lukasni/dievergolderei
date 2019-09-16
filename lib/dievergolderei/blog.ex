defmodule Dievergolderei.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  require Date
  alias Dievergolderei.Repo

  alias Dievergolderei.Util
  alias Dievergolderei.Blog.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Returns a list of recent posts sorted by publish date in descending order

  ## Examples

      iex> list_most_recent_published_posts(2) do
      [%Post{}, ...]
  """
  def list_most_recent_published_posts(count \\ 3) do
    Post
    |> filter_publish_on_in_past()
    |> order_by_published()
    |> limit(^count)
    |> Repo.all()
  end

  @doc """
  List blog posts published in a given month, sorted by publish date in descending order

  ## Examples

      iex> list_posts_published_in_month("01-2019")
      [%Post{}, ...]
  """
  def list_posts_published_in_month(month, year) do
    {:ok, start_date} = Date.new(year, month, 1)
    end_date = Date.add(start_date, Date.days_in_month(start_date))

    Post
    |> where([p], p.publish_on >= ^start_date)
    |> where([p], p.publish_on < ^end_date)
    |> order_by_published()
    |> Repo.all()
  end

  defp order_by_published(post) do
    post
    |> order_by(desc: :publish_on)
    |> order_by(desc: :inserted_at)
  end

  defp filter_publish_on_in_past(post) do
    post
    |> where([p], p.publish_on <= ^Date.utc_today())
  end

  @doc """
  Returns first day of month as a %Date{} for all months that have posts

  ## Examples

      iex> list_months()
      [%Date{}, ...]
  """
  def months_with_posts() do
    Post
    |> filter_publish_on_in_past()
    |> select([p], p.publish_on)
    |> Repo.all()
    |> Enum.map(&Util.first_day_of_month/1)
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.sort(fn a, b -> Date.compare(a, b) == :gt end)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
