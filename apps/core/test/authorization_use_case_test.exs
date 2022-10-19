defmodule FakeCreateForAuthorization do
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

defmodule FakeGetByEmailForAuthorization do
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

defmodule FakeGetById do
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

defmodule AuthorizationUseCaseTest do
  use ExUnit.Case
  alias User.UseCases.RegistrationUseCase
  alias User.UseCases.AuthorizationUseCase
  alias User.UseCases.AuthenticationUseCase
  alias FakeGetById
  alias FakeGetByEmailForAuthorization
  alias FakeCreateForAuthorization
  alias UUID

  test "authorization user" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForAuthorization
    )

    {_, id} = AuthenticationUseCase.auth(
      %{email: "test@gmail.com", password: "123456"},
      FakeGetByEmailForAuthorization
    )

    {result, _} = AuthorizationUseCase.auth(id, FakeGetById)

    :ets.delete(:users)

    assert result == :ok
  end

  test "wrong id" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateForAuthorization
    )

    {result, _} = AuthorizationUseCase.auth(UUID.uuid4(), FakeGetById)

    :ets.delete(:users)

    assert result == :error
  end
end
