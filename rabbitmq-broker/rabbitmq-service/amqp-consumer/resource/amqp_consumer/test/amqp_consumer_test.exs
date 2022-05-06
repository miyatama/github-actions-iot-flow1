defmodule AmqpConsumerTest do
  use ExUnit.Case
  doctest AmqpConsumer

  test "greets the world" do
    assert AmqpConsumer.hello() == :world
  end
end
