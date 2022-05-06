defmodule DummyProducerTest do
  use ExUnit.Case
  doctest DummyProducer

  test "greets the world" do
    assert DummyProducer.hello() == :world
  end
end
