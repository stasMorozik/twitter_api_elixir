import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rest, RestWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "VI+vNLERuFf6dSQrjIaZWxZB3B2Ves95qOsKpWztjLi5kWDcShnenxEUuRl39FHC",
  server: false

# In test we don't send emails.
config :rest, Rest.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
