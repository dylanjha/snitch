# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :snitch,
  ecto_repos: [Snitch.Repo]

# Configures the endpoint
config :snitch, SnitchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HVwKxjgXYJIcVM6bt7bAJvbedU7O8+MZwP9ushyZwpID3UGxWltPcMSKuGkfyXzf",
  render_errors: [view: SnitchWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Snitch.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mux,
  access_token_id: System.get_env("MUX_TOKEN_ID"),
  access_token_secret: System.get_env("MUX_TOKEN_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"