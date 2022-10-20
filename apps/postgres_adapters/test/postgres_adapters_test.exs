defmodule PostgresAdaptersTest do
  use ExUnit.Case
  use RepoCase
  alias Users.GetAdapter
  alias Users.GetByEmailAdapter
  alias Users.CreateAdapter
  alias User.UserEntity
  alias User.ValueObjects.EmailValueObject
  alias Common.ValueObjects.IdValueObject
  alias UUID

  doctest PostgresAdapters

  test "create users" do
    {_, user_entity} = UserEntity.new(%{name: "Joe", email: "joe@gmail.com", password: "123456"})

    {result, _} = CreateAdapter.create(user_entity)

    assert result == :ok
  end

  test "get user by id" do
    {_, user_entity} = UserEntity.new(%{name: "Joe", email: "joe@gmail.com", password: "123456"})

    CreateAdapter.create(user_entity)

    {result, _} = GetAdapter.get(user_entity.id)

    assert result == :ok
  end

  test "get user by email" do
    {_, user_entity} = UserEntity.new(%{name: "Joe", email: "joe@gmail.com", password: "123456"})

    CreateAdapter.create(user_entity)

    {result, _} = GetByEmailAdapter.get(user_entity.email)

    assert result == :ok
  end

  test "get user by id, user not found" do
    {_, user_entity} = UserEntity.new(%{name: "Joe", email: "joe@gmail.com", password: "123456"})

    CreateAdapter.create(user_entity)

    {result, _} = GetAdapter.get(%IdValueObject{value: UUID.uuid4()})

    assert result == :error
  end

  test "get user by email, user not found" do
    {_, user_entity} = UserEntity.new(%{name: "Joe", email: "joe@gmail.com", password: "123456"})

    CreateAdapter.create(user_entity)

    {result, _} = GetByEmailAdapter.get(%EmailValueObject{value: "test@gmail.com"})

    assert result == :error
  end
end
