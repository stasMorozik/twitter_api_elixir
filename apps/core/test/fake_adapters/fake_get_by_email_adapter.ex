defmodule FakeAdapters.FakeGetByEmailAdapter do
  alias User.Ports.GetByEmailPort
  alias Common.Errors.InfrastructureError
  alias User.ValueObjects.EmailValueObject

  @behaviour GetByEmailPort

  @spec get(EmailValueObject.t()) :: GetByEmailPort.ok() | GetByEmailPort.error()
  def get(email_value_object) when is_struct(email_value_object) do
    with email_value_object <- Map.from_struct(email_value_object),
         true <- email_value_object[:value] != nil,
         list <- :ets.lookup(:users, email_value_object.value),
         result <- length(list) > 0,
         false <- result == false do
      [head | _] = list
      {_, user_entity} = head
      {:ok, user_entity}
    else
      false -> {:error, InfrastructureError.new("Invalid email")}
      true -> {:error, InfrastructureError.new("User not found")}
    end
  end

  def get(_) do
    {:error, InfrastructureError.new("Invalid email")}
  end
end
