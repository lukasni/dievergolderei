defmodule Dievergolderei.Repo.Migrations.UpdateUserTables do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :confirmed_at, :naive_datetime
    end

    execute "UPDATE users SET confirmed_at = now()",""

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
