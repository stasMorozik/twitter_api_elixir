defmodule User.UseCases.AuthenticationUseCase do
  @moduledoc """
  Documentation for `AuthenticationUseCase`.
  """

  alias User.Ports.GetByEmailPort
  alias Common.Errors.DomainError
  alias Common.Errors.InfrastructureError
  alias User.ValueObjects.EmailValueObject
  alias User.UserEntity

  @type ok() :: {:ok, binary()}

  @type error() :: {:error, DomainError.t() | InfrastructureError.t()}

  @spec auth(UserEntity.auth_dto(), GetByEmailPort.t()) :: ok() | error()
  def auth(auth_dto, get_by_email_port) do
    with {:ok, email_value_object} = EmailValueObject.new(auth_dto[:email]),
         {:ok, user_entity} <- get_by_email_port.get(email_value_object),
         {:ok, _} <- UserEntity.validate_password(user_entity, auth_dto[:password]) do
      #instead of token i use uuid
      #later i will use jwt
      {:ok, user_entity.id.value}
    else
      {:error, some_error} -> {:error, some_error}
    end
  end
end
