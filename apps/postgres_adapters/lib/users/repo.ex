defmodule Users.Repo do
  use Ecto.Repo,
    otp_app: :postgres_adapters,
    adapter: Ecto.Adapters.Postgres
end
