import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :scrooge, Scrooge.Repo,
  username: "root",
  hostname: "localhost",
  database: "scrooge_test#{System.get_env("MIX_TEST_PARTITION")}",
  port: 26257,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :scrooge, ScroogeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "MwDrA1ikE/S0E+bkimDxqZcCPaFWEjgVTmXrRTA8/7LJtGSZZZv1ztiFZEA8HuVw",
  server: false

# In test we don't send emails.
config :scrooge, Scrooge.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Forces Oban to run inline
config :scrooge, Oban, testing: :inline

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Only in tests, remove the complexity from the password hashing algorithm
config :argon2_elixir, t_cost: 1, m_cost: 8

# Configure wallaby to use Selenium for browser tests
config :wallaby,
  base_url: System.get_env("WALLABY_URL", "http://host.docker.internal:4002"),
  driver: Wallaby.Selenium,
  otp_app: :scrooge,
  screenshot_dir: Path.join(__DIR__, "../test/screenshots"),
  screenshot_on_failure: true,
  selenium: [
    capabilities: %{
      browserName: System.get_env("WALLABY_BROWSER", "chrome"),
      javascriptEnabled: true,
      resolution: System.get_env("WALLABY_RESOLUTION", "1920x1080")
    },
    remote_url: System.get_env("WALLABY_SELENIUM_URL", "http://localhost:4444/wd/hub/")
  ]
