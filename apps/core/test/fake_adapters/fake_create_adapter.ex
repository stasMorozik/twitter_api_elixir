defmodule FakeAdapters.FakeCreateAdapter do
  alias User.Ports.CreatePort
  alias Common.Errors.InfrastructureError
  alias User.UserEntity

  @behaviour CreatePort

  @spec create(UserEntity.t()) :: CreatePort.ok() | CreatePort.error()
  def create(user_entity) do
    with true <- :ets.insert_new(:users, {user_entity.email.value, user_entity}),
         true <- :ets.insert_new(:users, {user_entity.id.value, user_entity}) do
      {:ok, true}
    else
      false -> {:error, InfrastructureError.new("User already exists")}
    end
  end
end
