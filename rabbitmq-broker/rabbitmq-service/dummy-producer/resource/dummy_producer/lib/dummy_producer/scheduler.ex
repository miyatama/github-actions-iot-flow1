defmodule DummyProducer.Scheduler do
  use Quantum, otp_app: :dummy_producer

  def publish() do
    DummyProducer.Publisher.publish()
  end
end
