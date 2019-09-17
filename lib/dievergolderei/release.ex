defmodule Dievergolderei.Release do
  @app :dievergolderei

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      # Code.require_file("priv/repo/seeds.exs")
      # TODO: figure out how to exclude Faker stuff from prod
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos() do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
