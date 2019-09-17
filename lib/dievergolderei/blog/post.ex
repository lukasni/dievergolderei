defmodule Dievergolderei.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :publish_on, :date
    field :slug, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :content, :publish_on])
    |> validate_required([:title, :slug, :content, :publish_on])
  end
end
