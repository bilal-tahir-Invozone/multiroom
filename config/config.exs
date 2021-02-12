# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :multiRooms,
  ecto_repos: [MultiRooms.Repo]

# Configures the endpoint
config :multiRooms, MultiRoomsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "emTkBJVtoXBFiTV2oHNtR1yCT679JaOw18D99se+xcvIQOqtFqgTqB58TuGEccwZ",
  render_errors: [view: MultiRoomsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MultiRooms.PubSub,
  live_view: [signing_salt: "qET4B9nk"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
