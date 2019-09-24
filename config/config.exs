# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :dievergolderei,
  ecto_repos: [Dievergolderei.Repo]

config :dievergolderei, DievergoldereiWeb.Gettext, default_locale: "de"

# Configures the endpoint
config :dievergolderei, DievergoldereiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GbGHdYKslelLVH8Bv1STveMW3vK//AHVQt8YL4t8sooPjaFGa+vpCo5ZtRFcamXB",
  render_errors: [view: DievergoldereiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Dievergolderei.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "WL42N5UNOYEc2v0m7pVyx8f+chokWkGw"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Arc uses local storage
config :waffle, storage: Waffle.Storage.Local

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
