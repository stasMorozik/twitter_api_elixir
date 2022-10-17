defmodule User.Ports.GetPort do
  @moduledoc """
  Documentation for `GetPort`.
  """

  alias Common.Errors.InfrastructureError
  alias Common.ValueObjects.IdValueObject
  alias User.UserEntity

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {:error, InfrastructureError.t()}

  @callback create(IdValueObject.t()) :: ok() | error()
end
