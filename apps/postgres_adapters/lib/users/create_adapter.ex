defmodule Users.CreateAdapter do
  @moduledoc """
  Documentation for `CreateAdapter`.
  """

  alias Ecto.Multi
  alias Users.Repo
  alias Users.Schema
  alias Common.Errors.InfrastructureError
  alias User.UserEntity
  alias User.Ports.CreatePort

  @behaviour CreatePort

  @spec create(UserEntity.t()) :: CreatePort.ok() | CreatePort.error()
  def create(user_entity) when is_struct(user_entity) do
    with user_entity <- Map.from_struct(user_entity),
         false <- user_entity[:id] == nil,
         false <- user_entity[:name] == nil,
         false <- user_entity[:email] == nil,
         false <- user_entity[:password] == nil,
         false <- is_struct(user_entity[:id]) == false,
         false <- is_struct(user_entity[:name]) == false,
         false <- is_struct(user_entity[:email]) == false,
         false <- is_struct(user_entity[:password]) == false,
         id <- Map.from_struct(user_entity[:id]),
         name <- Map.from_struct(user_entity[:name]),
         email <- Map.from_struct(user_entity[:email]),
         password <- Map.from_struct(user_entity[:password]),
         false <- id[:value] == nil,
         false <- name[:value] == nil,
         false <- email[:value] == nil,
         false <- password[:value] == nil do
      user_changeset = %Schema{} |> Schema.changeset(%{
        id: id.value,
        name: name.value,
        email: email.value,
        password: password.value
      })
      case Multi.new() |> Multi.insert(:users, user_changeset) |> Repo.transaction() do
        {:ok, _} -> {:ok, true}
        error ->
          with {:error, _, error_changeset, _} <- error,
               [head | _] <- error_changeset.errors,
               {:email, {"has already been taken", _}} <- head do
               {:error, InfrastructureError.new("User with this email already exists")}
          else
            _ -> {:error, InfrastructureError.new("Something went wrong")}
          end
      end
    else
      true -> {:error, InfrastructureError.new("Invalid input data")}
    end
  end

  def create(_) do
    {:error, InfrastructureError.new("Invalid input data")}
  end
end
