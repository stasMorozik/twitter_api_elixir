defmodule RegistrationUseCaseTest do
  use ExUnit.Case
  alias User.UseCases.RegistrationUseCase
  alias FakeAdapters.FakeCreateAdapter
  doctest User.UseCases.RegistrationUseCase

  test "new user" do
    :ets.new(:users, [:set, :public, :named_table])

    {result, _} = RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    :ets.delete(:users)

    assert result == :ok
  end


  test "user laready exists" do
    :ets.new(:users, [:set, :public, :named_table])

    RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    {result, _} = RegistrationUseCase.registry(
      %{name: "Name", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    :ets.delete(:users)

    assert result == :error
  end

  test "invalid input data" do
    {result, _} = RegistrationUseCase.registry(
      "",
      FakeCreateAdapter
    )

    assert result == :error
  end

  test "invalid name" do
    {result, _} = RegistrationUseCase.registry(
      %{name: "Name1", email: "test@gmail.com", password: "123456"},
      FakeCreateAdapter
    )

    assert result == :error
  end
end
