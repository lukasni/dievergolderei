defmodule Dievergolderei.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

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
  end

  def changeset_assoc(post, attrs) do
    post
    |> changeset(attrs)
    |> cast_assoc(:photo, required: false)
  end
end
