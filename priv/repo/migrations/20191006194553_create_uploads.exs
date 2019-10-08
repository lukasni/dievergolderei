defmodule Dievergolderei.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :filename, :string
      add :hash, :string
      add :content_type, :string
      add :size, :bigint

      remove :uuid
      remove :photo
    end

    create index(:photos, [:hash])

    alter table(:posts) do
      add :photo_id, references(:photos)
    end
  end
end
