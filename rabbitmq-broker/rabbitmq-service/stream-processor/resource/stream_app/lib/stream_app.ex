defmodule StreamApp do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("StreamApp.start()")
    import Supervisor.Spec, warn: false
    children = [
      worker(StreamApp.Consumer, []),
    ]
    opts = [strategy: :one_for_one, name: StreamApp.Consumer]
    Supervisor.start_link(children, opts)
  end

  def main(_args) do
    Logger.info("StreamApp.main()")
    StreamApp.Consumer.start()
  end
end
