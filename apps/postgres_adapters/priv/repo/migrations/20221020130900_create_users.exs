defmodule Users.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, default: fragment("now()")
    end

    create unique_index(:users, [:email])
  end
end
