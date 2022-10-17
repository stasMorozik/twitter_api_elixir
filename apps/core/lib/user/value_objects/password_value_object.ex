defmodule User.ValueObjects.PasswordValueObject do
  @moduledoc """
  Documentation for `NameValueObject`.
  """

  alias Bcrypt
  alias User.ValueObjects.PasswordValueObject
  alias Common.Errors.DomainError

  defstruct value: nil

  @type t() :: %PasswordValueObject{
          value: String.t()
        }

  @type ok() :: {:ok, PasswordValueObject.t()}

  @type error() :: {:error, DomainError.t()}

  @spec new(binary()) :: ok() | error()
  def new(password) when is_binary(password) do
    with true <- String.length(password) >= 5,
         true <- String.length(password) <= 10 do
      {
        :ok,
        %PasswordValueObject{
          value: Bcrypt.Base.hash_password(
            password,
            Bcrypt.Base.gen_salt(12)
          )
        }
      }
    else
      false -> {:error, DomainError.new("Invalid password")}
    end
  end

  def new(_) do
    {:error, DomainError.new("Invalid password")}
  end
end
