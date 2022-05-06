import Config

config :dummy_producer, DummyProducer.Scheduler, 
    jobs: [
      {"* * * * *", {DummyProducer.Scheduler, :publish, []}}
    ]
