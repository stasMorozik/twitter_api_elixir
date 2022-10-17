defmodule User.Ports.CreatePort do
  @moduledoc """
  Documentation for `CreatePort`.
  """

  alias Common.Errors.InfrastructureError
  alias User.UserEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, InfrastructureError.t()}

  @callback create(UserEntity.t()) :: ok() | error()
end
