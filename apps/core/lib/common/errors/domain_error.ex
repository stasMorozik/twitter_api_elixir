defmodule Common.Errors.DomainError do
  @moduledoc """
  Documentation for `DomainError`.
  """
  alias Common.Errors.DomainError

  defstruct message: nil

  @type t() :: %DomainError{
          message: String.t()
        }

  @spec new(binary()) :: DomainError.t()
  def new(message) when is_binary(message) do
    %DomainError{message: message}
  end

  def new(_) do
    %DomainError{message: "Domain error"}
  end
end
