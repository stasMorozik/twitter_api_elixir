defmodule PostgresAdaptersTest do
  use ExUnit.Case
  doctest PostgresAdapters

  test "greets the world" do
    assert PostgresAdapters.hello() == :world
  end
end
