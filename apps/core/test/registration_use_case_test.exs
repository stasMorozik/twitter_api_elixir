defmodule FakeCreate do
  alias User.Ports.CreatePort
  alias Common.Errors.InfrastructureError
  alias User.UserEntity

  @behaviour CreatePort

  @spec create(UserEntity.t()) :: CreatePort.ok() | CreatePort.error()
  def create(user_entity) do
    list = :ets.lookup(:users, user_entity.email.value)
    with true <- length(list) == 0 do
      :ets.insert_new(:users, {user_entity.email.value, user_entity})
      {:ok, true}
    else
      false -> {:error, InfrastructureError.new("User already exists")}
    end
  end
end

defmodule RegistrationUseCaseTest do
  use ExUnit.Case
  alias User.UseCases.RegistrationUseCase
  alias FakeCreate
  doctest User.UseCases.RegistrationUseCase

  test "new user" do
    :ets.new(:users, [:set, :public, :named_table])

    {result, _} = RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreate
    )

    :ets.delete(:users)

    assert result == :ok
  end


  test "user laready exists" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreate
    )

    {result, _} = RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreate
    )

    :ets.delete(:users)

    assert result == :error
  end
end
