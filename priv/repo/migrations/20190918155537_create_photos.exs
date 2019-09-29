defmodule Dievergolderei.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :photo, :string
      add :uuid, :uuid
      add :description, :text
      add :title, :string
      add :slug, :string
      add :in_gallery, :boolean, default: true, null: false

      timestamps()
    end

    create index(:photos, [:in_gallery])
  end
end
