defmodule Common.Errors.InfrastructureError do
  @moduledoc """
  Documentation for `InfrastructureError`.
  """

  alias Common.Errors.InfrastructureError

  defstruct message: nil

  @type t() :: %InfrastructureError{
          message: String.t()
        }

  @spec new(binary()) :: InfrastructureError.t()
  def new(message) when is_binary(message) do
    %InfrastructureError{message: message}
  end

  def new(_) do
    %InfrastructureError{message: "Infrastructure error"}
  end
end
