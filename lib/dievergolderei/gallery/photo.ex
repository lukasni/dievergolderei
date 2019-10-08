defmodule Dievergolderei.Gallery.Photo do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :in_gallery, :boolean, default: true
    field :description, :string
    field :title, :string
    field :slug, :string

    field :content_type, :string
    field :filename, :string
    field :hash, :string
    field :size, :integer

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:in_gallery, :description, :title, :filename, :hash, :content_type, :size])
    |> validate_required([:filename, :hash, :content_type, :size, :in_gallery])
    |> validate_number(:size, greater_than: 0)
  end

  def local_path(%{id: id, filename: filename}) do
    [upload_directory(), "#{id}-#{filename}"]
    |> Path.join()
  end

  def upload_directory do
    Application.get_env(:dievergolderei, Dievergolderei.Photo, [])
    |> Keyword.get(:upload_directory)
    |> Path.join("photos")
  end
end
