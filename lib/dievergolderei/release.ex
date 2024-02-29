defmodule Dievergolderei.Release do
  @moduledoc """
  Release tasks for migrating and seeding the database in production
  """
  @app :dievergolderei

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    Code.require_file("priv/repo/seeds.exs")
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos() do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
