defmodule DummyProducer.Publisher do
  use AMQP
  require Logger

  def publish() do 
    Logger.info("DummyProducer.Publisher.publish()")
    {:ok, conn} = Connection.open("amqp://rabbitmq:rabbitmq@broker:5672")
    {:ok, chan} = Channel.open(conn)
    status = AMQP.Basic.publish(chan, "", "github-actions-event", "{\"event\": \"merge\", \"branch\": \"main\"}")
    Logger.info("publish statsu: #{status}")
    status = AMQP.Basic.publish(chan, "", "github-actions-event", "{\"event\": \"merge\", \"branch\": \"develop\"}")
    Logger.info("publish statsu: #{status}")
    Connection.close(conn)
  end
end


