defmodule AuthenticationUseCaseTest do
  use ExUnit.Case
  alias User.UseCases.AuthenticationUseCase
  alias User.UseCases.RegistrationUseCase
  alias FakeAdapters.FakeGetByEmailAdapter
  alias FakeAdapters.FakeCreateAdapter
  doctest User.UseCases.AuthenticationUseCase

  test "authentication user" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    {result, _} = AuthenticationUseCase.auth(
      %{email: "test@gmail.com", password: "123456"},
      FakeGetByEmailAdapter
    )

    :ets.delete(:users)

    assert result == :ok
  end

  test "user not found" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    {result, _} = AuthenticationUseCase.auth(
      %{email: "test1@gmail.com", password: "123456"},
      FakeGetByEmailAdapter
    )

    :ets.delete(:users)

    assert result == :error
  end

  test "wrong password" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    {result, _} = AuthenticationUseCase.auth(
      %{email: "test@gmail.com", password: "1234567"},
      FakeGetByEmailAdapter
    )

    :ets.delete(:users)

    assert result == :error
  end
end
