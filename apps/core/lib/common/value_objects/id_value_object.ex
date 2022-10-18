defmodule Common.ValueObjects.IdValueObject do
  @moduledoc """
  Documentation for `IdValueObject`.
  """

  alias UUID
  alias Common.ValueObjects.IdValueObject
  alias Common.Errors.DomainError

  defstruct value: nil

  @type t() :: %IdValueObject{
          value: binary()
        }

  @type ok() :: {:ok, IdValueObject.t()}

  @type error() :: {:error, DomainError.t()}

  @spec new(binary()) :: ok() | error()
  def new(uuid) when is_binary(uuid) do
    case UUID.info(uuid) do
      {:ok, _} -> {:ok, %IdValueObject{value: uuid}}
      {:error, _} -> {:error, DomainError.new("Invalid id")}
    end
  end

  def new(_) do
    {:error, DomainError.new("Invalid id")}
  end
end
