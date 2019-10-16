defmodule Dievergolderei.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @slug_max_length 20

  schema "posts" do
    field :content, :string
    field :publish_on, :date
    field :slug, :string
    field :title, :string
    belongs_to :photo, Dievergolderei.Gallery.Photo

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :content, :publish_on, :photo_id])
    |> validate_required([:title, :content, :publish_on])
    |> put_slug()
  end

  defp put_slug(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{slug: _slug}} ->
        changeset

      %Ecto.Changeset{valid?: true, changes: %{title: title}} ->
        put_change(changeset, :slug, slugify(title))

      _ ->
        changeset
    end
  end

  defp slugify(title) do
    title
    |> Slugger.slugify_downcase()
    |> Slugger.truncate_slug(@slug_max_length)
  end
end
