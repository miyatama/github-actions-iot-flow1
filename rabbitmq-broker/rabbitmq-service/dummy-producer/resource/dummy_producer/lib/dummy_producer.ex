defmodule DummyProducer do
  require Logger
  use Application

  def start(_type, _args) do
    Logger.info("DummyProducer.start()")
    import Supervisor.Spec, warn: false
    children = [
      worker(DummyProducer.Runner, []),
      DummyProducer.Scheduler
    ]
    opts = [strategy: :one_for_one, name: DummyProducer.Runner]
    Supervisor.start_link(children, opts)
  end

  def publish() do
    Logger.info("DummyProducer.publish()")
    DummyProducer.Runner.run()
  end
  
  def main(_args) do
    Logger.info("DummyProducer.main()")
    DummyProducer.Runner.run()
  end
end
