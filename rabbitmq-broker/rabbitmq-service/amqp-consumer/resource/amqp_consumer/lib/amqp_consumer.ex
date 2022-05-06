defmodule AmqpConsumer do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("AmqpConsumer.start()")
    import Supervisor.Spec, warn: false
    children = [
      worker(AmqpConsumer.Consumer, []),
    ]
    opts = [strategy: :one_for_one, name: AmqpConsumer.Consumer]
    Supervisor.start_link(children, opts)
  end

  def main(_args) do
    Logger.info("AmqpConsumer.main()")
    AmqpConsumer.Consumer.start()
  end
end
