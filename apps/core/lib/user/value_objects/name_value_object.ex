defmodule User.ValueObjects.NameValueObject do
  @moduledoc """
  Documentation for `NameValueObject`.
  """

  alias User.ValueObjects.NameValueObject
  alias Common.Errors.DomainError

  defstruct value: nil

  @type t() :: %NameValueObject{
          value: String.t()
        }

  @type ok() :: {:ok, NameValueObject.t()}

  @type error() :: {:error, DomainError.t()}

  @spec new(binary()) :: ok() | error()
  def new(name) when is_binary(name) do
    with true <- String.match?(name, ~r/^[a-zA-Z]+$/),
         true <- String.length(name) > 2 do
      {:ok, %NameValueObject{value: name}}
    else
      false -> {:error, DomainError.new("Invalid name")}
    end
  end

  def new(_) do
    {:error, DomainError.new("Invalid name")}
  end
end
