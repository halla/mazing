# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config


# Configures the endpoint
config :mazing, MazingUi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cuDe5zu+6YjFccXjiPheh3j/Bg2/7VPB+7QqTDi8t5LUDY2iKO3r2fcoGgsIEVWM",
  render_errors: [view: MazingUi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MazingUi.PubSub,
           adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "bPmFVFstvK4oGyZcuWNbNHOyCEub/lNe"
  ]

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]


# revisit
config :logger,
  handle_otp_reports: true,
  handle_sasl_reports: true


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


