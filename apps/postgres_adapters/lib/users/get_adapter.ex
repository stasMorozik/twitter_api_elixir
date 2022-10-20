defmodule Users.GetAdapter do
  @moduledoc """
  Documentation for `GetAdapter`.
  """

  import Ecto.Query
  alias Users.Repo
  alias Users.Schema
  alias User.Ports.GetPort
  alias Common.Errors.InfrastructureError
  alias Common.ValueObjects.IdValueObject
  alias User.ValueObjects.NameValueObject
  alias User.ValueObjects.EmailValueObject
  alias User.UserEntity

  @behaviour GetPort

  @spec get(IdValueObject.t()) :: GetPort.ok() | GetPort.error()
  def get(id_value_object) when is_struct(id_value_object) do
    with id_value_object <- Map.from_struct(id_value_object),
         false <- id_value_object[:value] == nil,
         query <- from(
            u in Schema,
            where: u.id == ^id_value_object.value
          ),
         maybe_user_map <- Repo.one(query),
         true <- maybe_user_map != nil do
      {
        :ok,
        %UserEntity{
          id: %IdValueObject{value: maybe_user_map.id},
          name: %NameValueObject{value: maybe_user_map.name},
          email: %EmailValueObject{value: maybe_user_map.email}
        }
      }
    else
      true -> {:error, InfrastructureError.new("Invalid id")}
      false -> {:error, InfrastructureError.new("User not found")}
    end
  end

  def get(_) do
    {:error, InfrastructureError.new("Invalid id")}
  end
end
