defmodule StreamAppTest do
  use ExUnit.Case
  doctest StreamApp

  test "greets the world" do
    assert StreamApp.hello() == :world
  end
end
