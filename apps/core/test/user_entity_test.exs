defmodule UserEntityTest do
  use ExUnit.Case
  alias User.UserEntity
  doctest User.UserEntity

  test "new user" do
    {result, _} = UserEntity.new(%{name: "Name", email: "test@gmail.com", password: "123456"})
    assert result == :ok
  end

  test "invalid input data" do
    {result, _} = UserEntity.new("")
    assert result == :error
  end

  test "invalid name" do
    {result, _} = UserEntity.new(%{name: "Name1", email: "test@gmail.com", password: "123456"})
    assert result == :error
  end

  test "invalid email" do
    {result, _} = UserEntity.new(%{name: "Name", email: "test@gmail.", password: "123456"})
    assert result == :error
  end

  test "invalid password" do
    {result, _} = UserEntity.new(%{name: "Name", email: "test@gmail.com", password: "1234"})
    assert result == :error
  end
end
