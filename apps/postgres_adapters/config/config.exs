import Config

config :postgres_adapters, ecto_repos: [Users.Repo]

config :postgres_adapters, Users.Repo,
  database: "youdo_api_elixir",
  username: "db_user",
  password: "12345",
  hostname: "localhost"

import_config "#{Mix.env}.exs"
