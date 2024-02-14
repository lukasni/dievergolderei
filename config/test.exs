import Config

config :dievergolderei, Dievergolderei.Photo, upload_directory: "/tmp/dv_uploads"

# Configure your database
config :dievergolderei, Dievergolderei.Repo,
  # username: "postgres",
  # password: "postgres",
  # hostname: "localhost",
  socket_dir: "/var/run/postgresql",
  database: "dievergolderei_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dievergolderei, DievergoldereiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Lower Argon2 cost for testing
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

# Print only warnings and errors during test
config :logger, level: :warning
