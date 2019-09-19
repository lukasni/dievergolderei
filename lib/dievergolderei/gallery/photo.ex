defmodule Dievergolderei.Gallery.Photo do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :in_gallery, :boolean, default: false
    field :photo, Dievergolderei.Photo.Type
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> Map.update(:uuid, Ecto.UUID.generate(), fn val -> val || Ecto.UUID.generate() end)
    |> cast(attrs, [:in_gallery])
    |> cast_attachments(attrs, [:photo])
    |> validate_required([:photo])
  end
end
