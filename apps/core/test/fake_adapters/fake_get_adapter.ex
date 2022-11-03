defmodule FakeAdapters.FakeGetAdapter do
  alias User.Ports.GetPort
  alias Common.Errors.InfrastructureError
  alias Common.ValueObjects.IdValueObject

  @behaviour GetPort

  @spec get(IdValueObject.t()) :: GetPort.ok() | GetPort.error()
  def get(id_value_object) when is_struct(id_value_object) do
    with id_value_object <- Map.from_struct(id_value_object),
         true <- id_value_object[:value] != nil,
         list <- :ets.lookup(:users, id_value_object.value),
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
