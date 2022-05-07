defmodule StreamApp.Consumer do
  use GenServer
  use AMQP
  require Logger

  def start_link do
    Logger.info("StreamApp.Consumer.strat_link()")
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(_opts) do
    Logger.info("StreamApp.Consumer.init()")
    {:ok, conn} = Connection.open("amqp://rabbitmq:rabbitmq@broker:5672")
    {:ok, chan} = Channel.open(conn)

    :ok = Basic.qos(chan, prefetch_count: 10)
    {:ok, _consumer_tag} = Basic.consume(chan, get_describe_topic())
    {:ok, chan}
  end

  def get_describe_topic() do
    Logger.info("StreamApp.Consumer.get_describe_topic()")
    System.get_env("GITHUB_TOPIC")
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("StreamApp.Consumer.handle_info(:basic_consume_ok)")
    {:noreply, chan}
  end

  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("StreamApp.Consumer.handle_info(:basic_cancel)")
    {:stop, :normal, chan}
  end

  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("StreamApp.Consumer.handle_info(:basic_cancel_ok)")
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    Logger.info("StreamApp.Consumer.handle_info(:basic_deliver)")
    consume(chan, tag, redelivered, payload)
    {:noreply, chan}
  end

  defp consume(channel, tag, redelivered, payload) do
    Logger.info("StreamApp.Consumer.consume() - #{payload}")
    Jason.decode!(payload, [{:keys, :atoms}])
    |> publish(channel)

  rescue
    exception ->
      :ok = Basic.reject channel, tag, requeue: not redelivered
      IO.puts "Error: #{exception}"
  end

  defp publish(%{event: event, branch: branch}, channel) when event == "merge" and branch == "main" do
    Logger.info("publish(channel, map)")
    status = AMQP.Basic.publish(channel, "", publish_topic(), "{\"event\": \"wakeup\", \"device\": \"yobikomi\"}")
    Logger.info("publish status: #{status}")
  end

  defp publish(data, channel) do
    Logger.info("not rise device event")
    Logger.info(data)
  end

  defp publish_topic() do
    Logger.info("StreamApp.Consumer.publish_topic()")
    System.get_env("DEVICE_TOPIC")
  end
end
