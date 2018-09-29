# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :customizer, :setup,
       prefix: "./priv/static/"

# General application configuration
config :customizer,
  ecto_repos: [Customizer.Repo]

# Configures the endpoint
config :customizer, CustomizerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3wMETDoG52IRBhSwHmjOOS0iugGjfek1HmBTfk9Kby3kB7/KD1NPSDFACGANYP03",
  render_errors: [view: CustomizerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Customizer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
