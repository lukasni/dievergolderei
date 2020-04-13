defmodule Dievergolderei.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :price, :decimal
      add :filename, :string
      add :hash, :string
      add :size, :integer
      add :content_type, :string
      add :reserved, :boolean, default: false, null: false

      timestamps()
    end

  end
end
