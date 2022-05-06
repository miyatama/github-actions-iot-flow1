defmodule DummyProducer.Runner do
  use GenServer
  require Logger

  def run() do
    Logger.info("DummyProducer.Runner.run()")
    DummyProducer.Publisher.publish()
  end

  def init(init_arg) do
    Logger.info("DummyProducer.Runner.init()")
    {:ok, init_arg}
  end

  def start_link do
    Logger.info("DummyProducer.Runner.start_link()")
    GenServer.start_link(__MODULE__, HashDict.new, name: :dummy_producer)
  end

  def handle_call(:publish, _from, _state) do
    Logger.info("DummyProducer.Runner.handle_call()")
    DummyProducer.Publisher.publish()
  end
end
