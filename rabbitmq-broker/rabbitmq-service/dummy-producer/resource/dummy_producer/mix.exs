defmodule DummyProducer.MixProject do
  use Mix.Project

  def project do
    [
      app: :dummy_producer,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: DummyProducer],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {DummyProducer, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:amqp, "~> 3.1"},
      {:quantum, "~> 3.0"}
    ]
  end
end
