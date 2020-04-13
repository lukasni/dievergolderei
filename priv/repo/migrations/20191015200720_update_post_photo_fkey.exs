defmodule Dievergolderei.Repo.Migrations.UpdatePostPhotoFkey do
  use Ecto.Migration

  def up do
    drop constraint(:posts, "posts_photo_id_fkey")

    alter table(:posts) do
      modify :photo_id, references(:photos, on_delete: :nilify_all)
    end
  end

  def down do
    drop constraint(:posts, "posts_photo_id_fkey")

    alter table(:posts) do
      modify :photo_id, references(:photos, on_delete: :nothing)
    end
  end
end
