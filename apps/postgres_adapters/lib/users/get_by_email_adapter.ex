defmodule Users.GetByEmailAdapter do
  @moduledoc """
  Documentation for `GetByEmailAdapter`.
  """

  import Ecto.Query
  alias Users.Repo
  alias Users.Schema
  alias User.Ports.GetByEmailPort
  alias Common.Errors.InfrastructureError
  alias Common.ValueObjects.IdValueObject
  alias User.ValueObjects.EmailValueObject
  alias User.ValueObjects.NameValueObject
  alias User.ValueObjects.PasswordValueObject
  alias User.UserEntity

  @behaviour GetByEmailPort

  @spec get(EmailValueObject.t()) :: GetByEmailPort.ok() | GetByEmailPort.error()
  def get(email_value_object) when is_struct(email_value_object) do
    with email_value_object <- Map.from_struct(email_value_object),
         false <- email_value_object[:value] == nil,
         query <- from(
            u in Schema,
            where: u.email == ^email_value_object.value
          ),
         maybe_user_map <- Repo.one(query),
         true <- maybe_user_map != nil do
      {
        :ok,
        %UserEntity{
          id: %IdValueObject{value: maybe_user_map.id},
          name: %NameValueObject{value: maybe_user_map.name},
          email: %EmailValueObject{value: maybe_user_map.email},
          password: %PasswordValueObject{value: maybe_user_map.password}
        }
      }
    else
      true -> {:error, InfrastructureError.new("Invalid email")}
      false -> {:error, InfrastructureError.new("User not found")}
    end
  end

  def get(_) do
    {:error, InfrastructureError.new("Invalid email")}
  end
end
