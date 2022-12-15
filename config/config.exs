# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :scrooge,
  ecto_repos: [Scrooge.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :scrooge, ScroogeWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ScroogeWeb.ErrorHTML, json: ScroogeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Scrooge.PubSub,
  live_view: [signing_salt: "3o1gx1n3"]

config :scrooge, Scrooge.Repo,
  after_connect: {Postgrex, :query!, ["SET SESSION application_name = \"scrooge\";", []]},
  migration_lock: false,
  migration_primary_key: [name: :uuid, type: :binary_id],
  migration_timestamps: [type: :utc_datetime],
  telemetry_prefix: [:repo],
  encoding: "UTF-8"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :scrooge, Scrooge.Mailer, adapter: Swoosh.Adapters.Local

# Setup PromEx to export Prometheus metrics
config :scrooge, Scrooge.PromEx,
  drop_metrics_groups: [],
  grafana: [
    host: "http://localhost:3000",
    upload_dashboards_on_start: false,
    folder_name: "Scrooge",
    annotate_app_lifecycle: false
  ],
  manual_metrics_start_delay: :no_delay,
  metrics_server: [
    port: 4080,
    path: "/",
    protocol: :http
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args: ~w(
      js/app.js
      --bundle
      --target=es2017
      --outdir=../priv/static/assets
      --external:/fonts/*
      --external:/images/*
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.1.8",
  default: [
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
import_config "#{config_env()}.exs"
