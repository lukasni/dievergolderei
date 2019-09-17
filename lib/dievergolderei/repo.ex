defmodule Dievergolderei.Repo do
  use Ecto.Repo,
    otp_app: :dievergolderei,
    adapter: Ecto.Adapters.Postgres
end
