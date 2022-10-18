defmodule User.UseCases.AuthorizationUseCase do
  @moduledoc """
  Documentation for `AuthorizationUseCase`.
  """

  alias User.UserEntity
  alias Common.Errors.DomainError
  alias Common.Errors.InfrastructureError
  alias Common.ValueObjects.IdValueObject
  alias User.Ports.GetPort

  @type ok() :: {:ok, UserEntity.t()}

  @type error() :: {:error, DomainError.t() | InfrastructureError.t()}

  @spec auth(binary(), GetPort.t()) :: ok() | error()
  def auth(id, get_port) do
    with {:ok, id_value_object} <- IdValueObject.new(id),
         {:ok, user_entity} <- get_port.get(id_value_object) do
      {:ok, user_entity}
    else
      {:error, some_error} -> {:error, some_error}
    end
  end
end
