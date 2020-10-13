# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :live_data_demo, LiveDataDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5ap2rlJ/5BzPUoYp4h6D1LfH3iHayx4vDRH68s1IB30nH7aohN+HrnU18QFIAa0b",
  render_errors: [view: LiveDataDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveDataDemo.PubSub,
  live_view: [signing_salt: "PO5avl8K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# used to map a reducer/data key to observable_gen_server to launch
config :live_data, module_mapper: %{"App" => LiveDataDemoWeb.LiveData.App2}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :live_data_demo, :reducer, LiveDataDemo.RootReducer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
