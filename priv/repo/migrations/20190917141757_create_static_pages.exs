defmodule Dievergolderei.Repo.Migrations.CreateStaticPages do
  use Ecto.Migration

  def change do
    create table(:static_pages) do
      add :name, :string
      add :content, :text

      timestamps()
    end

  end
end
