defmodule Dievergolderei.Repo.Migrations.CreateHours do
  use Ecto.Migration

  def change do
    create table(:hours) do
      add :label, :string
      add :times, :string
      add :active, :boolean, default: false, null: false
      add :list_position, :integer

      timestamps()
    end

  end
end
