defmodule FakeCreateForRegistration do
  alias User.Ports.CreatePort
  alias Common.Errors.InfrastructureError
  alias User.UserEntity

  @behaviour CreatePort

  @spec create(UserEntity.t()) :: CreatePort.ok() | CreatePort.error()
  def create(user_entity) do
    with true <- :ets.insert_new(:users, {user_entity.email.value, user_entity}) do
      {:ok, true}
    else
      false -> {:error, InfrastructureError.new("User already exists")}
    end
  end
end

defmodule RegistrationUseCaseTest do
  use ExUnit.Case
  alias User.UseCases.RegistrationUseCase
  alias FakeCreateForRegistration
  doctest User.UseCases.RegistrationUseCase

  test "new user" do
    :ets.new(:users, [:set, :public, :named_table])

    {result, _} = RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForRegistration
    )

    :ets.delete(:users)

    assert result == :ok
  end


  test "user laready exists" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForRegistration
    )

    {result, _} = RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForRegistration
    )

    :ets.delete(:users)

    assert result == :error
  end

  test "invalid input data" do
    {result, _} = RegistrationUseCase.registry(
      "",
      FakeCreateForRegistration
    )

    assert result == :error
  end

  test "invalid name" do
    {result, _} = RegistrationUseCase.registry(
      %{name: "Name1", email: "test@gmail.com", password: "123456"},
      FakeCreateForRegistration
    )

    assert result == :error
  end
end
