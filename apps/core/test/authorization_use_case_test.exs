defmodule AuthorizationUseCaseTest do
  use ExUnit.Case
  alias User.UseCases.RegistrationUseCase
  alias User.UseCases.AuthorizationUseCase
  alias User.UseCases.AuthenticationUseCase
  alias FakeAdapters.FakeGetAdapter
  alias FakeAdapters.FakeGetByEmailAdapter
  alias FakeAdapters.FakeCreateAdapter
  alias UUID

  test "authorization user" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    {_, id} = AuthenticationUseCase.auth(
      %{email: "test@gmail.com", password: "123456"},
      FakeGetByEmailAdapter
    )

    {result, _} = AuthorizationUseCase.auth(id, FakeGetAdapter)

    :ets.delete(:users)

    assert result == :ok
  end

  test "wrong id" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    {result, _} = AuthorizationUseCase.auth(UUID.uuid4(), FakeGetAdapter)

    :ets.delete(:users)

    assert result == :error
  end
end
