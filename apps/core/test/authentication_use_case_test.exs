defmodule FakeCreateForAuthentication do
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

defmodule FakeGetByEmail do
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

defmodule AuthenticationUseCaseTest do
  use ExUnit.Case
  alias User.UseCases.AuthenticationUseCase
  alias User.UseCases.RegistrationUseCase
  alias FakeCreateForAuthentication
  alias FakeGetByEmail
  doctest User.UseCases.AuthenticationUseCase

  test "authentication user" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForAuthentication
    )

    {result, _} = AuthenticationUseCase.auth(
      %{email: "test@gmail.com", password: "123456"},
      FakeGetByEmail
    )

    :ets.delete(:users)

    assert result == :ok
  end

  test "user not found" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForAuthentication
    )

    {result, _} = AuthenticationUseCase.auth(
      %{email: "test1@gmail.com", password: "123456"},
      FakeGetByEmail
    )

    :ets.delete(:users)

    assert result == :error
  end

  test "wrong password" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForAuthentication
    )

    {result, _} = AuthenticationUseCase.auth(
      %{email: "test@gmail.com", password: "1234567"},
      FakeGetByEmail
    )

    :ets.delete(:users)

    assert result == :error
  end
end
