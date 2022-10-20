defmodule Users.Schema do
  @moduledoc """
  Documentation for `Schema`.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :created, :utc_datetime
  end


  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:name, :email, :password, :id])
    |> validate_required([:name, :email, :password, :id])
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:id, name: :users_pkey)
  end
end
