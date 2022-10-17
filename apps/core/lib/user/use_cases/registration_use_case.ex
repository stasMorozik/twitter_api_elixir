defmodule User.UseCases.RegistrationUseCase do
  @moduledoc """
  Documentation for `UserEntity`.
  """

  alias User.UserEntity
  alias User.Ports.CreatePort
  alias Common.Errors.DomainError
  alias Common.Errors.InfrastructureError

  @type ok() :: {:ok, true}

  @type error() :: {:error, DomainError.t() | InfrastructureError.t()}

  @spec registry(UserEntity.create_dto(), CreatePort.t()) :: ok() | error()
  def registry(create_dto, create_port) do
    with  {:ok, user_entity} <- UserEntity.new(create_dto),
          {:ok, true} <- create_port.create(user_entity) do
      {:ok, true}
    else
      {:error, some_error} -> {:error, some_error}
    end
  end
end
