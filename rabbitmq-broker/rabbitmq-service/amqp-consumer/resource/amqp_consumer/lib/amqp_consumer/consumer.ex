defmodule AmqpConsumer.Consumer do
  use GenServer
  use AMQP
  require Logger

  def start_link do
    Logger.info("AmqpConsumer.Consumer.strat_link()")
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(_opts) do
    Logger.info("AmqpConsumer.Consumer.init()")
    {:ok, conn} = Connection.open("amqp://rabbitmq:rabbitmq@broker:5672")
    {:ok, chan} = Channel.open(conn)

    :ok = Basic.qos(chan, prefetch_count: 10)
    {:ok, _consumer_tag} = Basic.consume(chan, get_describe_topic())
    {:ok, chan}
  end

  def get_describe_topic() do
    Logger.info("AmqpConsumer.Consumer.get_describe_topic()")
    System.get_env("SUBSCRIBE_TOPIC")
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("AmqpConsumer.Consumer.handle_info(:basic_consume_ok)")
    {:noreply, chan}
  end

  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("AmqpConsumer.Consumer.handle_info(:basic_cancel)")
    {:stop, :normal, chan}
  end

  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("AmqpConsumer.Consumer.handle_info(:basic_cancel_ok)")
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    Logger.info("AmqpConsumer.Consumer.handle_info(:basic_deliver)")
    consume(chan, tag, redelivered, payload)
    {:noreply, chan}
  end

  defp consume(channel, tag, redelivered, payload) do
    :ok = Basic.ack channel, tag
    Logger.info("AmqpConsumer.Consumer.consume() - #{payload}")
  rescue
    exception ->
      :ok = Basic.reject channel, tag, requeue: not redelivered
      IO.puts "Error converting #{payload} to integer"
  end
end
