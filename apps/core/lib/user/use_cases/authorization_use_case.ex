defmodule User.UseCases.AuthorizationUseCase do
  @moduledoc """
  Documentation for `AuthorizationUseCase`.
  """

  alias Common.Errors.DomainError
  alias Common.Errors.InfrastructureError
  alias Common.ValueObjects.IdValueObject
  alias User.Ports.GetPort

  @type ok() :: {:ok, %{name: binary(), email: binary(), id: binary()}}

  @type error() :: {:error, DomainError.t() | InfrastructureError.t()}

  @spec auth(binary(), GetPort.t()) :: ok() | error()
  def auth(id, get_port) do
    with {:ok, id_value_object} <- IdValueObject.new(id),
         {:ok, user_entity} <- get_port.get(id_value_object) do
      {
        :ok,
        %{
          id: user_entity.id.value,
          name: user_entity.name.value,
          email: user_entity.email.value
        }
      }
    else
      {:error, some_error} -> {:error, some_error}
    end
  end
end
