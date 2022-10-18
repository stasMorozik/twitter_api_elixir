defmodule User.Ports.GetByEmailPort do
  @moduledoc """
  Documentation for `GetByEmailPort`.
  """

  alias Common.Errors.InfrastructureError
  alias Common.ValueObjects.EmailValueObject
  alias User.UserEntity

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {:error, InfrastructureError.t()}

  @callback get(EmailValueObject.t()) :: ok() | error()
end
