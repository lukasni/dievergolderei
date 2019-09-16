defmodule Dievergolderei.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :slug, :string
      add :content, :text
      add :publish_on, :date

      timestamps()
    end
  end
end
