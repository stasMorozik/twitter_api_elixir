defmodule User.ValueObjects.EmailValueObject do
  @moduledoc """
  Documentation for `EmailValueObject`.
  """

  alias User.ValueObjects.EmailValueObject
  alias Common.Errors.DomainError

  defstruct value: nil

  @type t() :: %EmailValueObject{
          value: String.t()
        }

  @type ok() :: {:ok, EmailValueObject.t()}

  @type error() :: {:error, DomainError.t()}

  @spec new(binary()) :: ok() | error()
  def new(email) when is_binary(email) do
    case String.match?(email, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/) do
      true -> {:ok, %EmailValueObject{value: email}}
      false -> {:error, DomainError.new("Email is invalid")}
    end
  end

  def new(_) do
    {:error, DomainError.new("Invalid Email")}
  end
end
