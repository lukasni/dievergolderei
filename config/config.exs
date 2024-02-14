# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :dievergolderei,
  ecto_repos: [Dievergolderei.Repo]

config :dievergolderei, Dievergolderei.Accounts.User, password_length: [min: 8, max: 256]

config :dievergolderei, DievergoldereiWeb.Gettext, default_locale: "de"

# Configures the endpoint
config :dievergolderei, DievergoldereiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  secret_key_base: "GbGHdYKslelLVH8Bv1STveMW3vK//AHVQt8YL4t8sooPjaFGa+vpCo5ZtRFcamXB",
  render_errors: [view: DievergoldereiWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Dievergolderei.PubSub,
  live_view: [signing_salt: "NyYC1qOQ"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  dievergolderei: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
