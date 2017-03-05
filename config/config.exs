use Mix.Config

import_config "../apps/*/config/config.exs"

config :logger,
  handle_otp_reports: true,
  handle_sasl_reports: true

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: ~w(correlation_id queue request_id user_id)a 
