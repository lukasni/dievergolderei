defmodule Dievergolderei.Gallery.Photo do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :in_gallery, :boolean, default: false
    field :photo, Dievergolderei.Photo.Type
    field :uuid, Ecto.UUID

    field :description, :string
    field :title, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> generate_uuid()
    |> cast(attrs, [:in_gallery, :description])
    |> cast_attachments(attrs, [:photo])
    |> validate_required([:photo])
  end

  defp generate_uuid(photo) do
    photo
    |> Map.update(:uuid, Ecto.UUID.generate(), fn val -> val || Ecto.UUID.generate() end)
  end
end
