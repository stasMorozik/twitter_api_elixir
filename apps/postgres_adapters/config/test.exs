import Config

config :postgres_adapters, Users.Repo,
  database: "twitter_api_elixir",
  username: "db_user",
  password: "12345",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
