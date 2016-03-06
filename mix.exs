defmodule Webpay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :webpay,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :poison,
        :httpoison
      ],
      mod: {Webpay, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.1"},
      {:poison, "~> 2.1"},
      {:exvcr, "~> 0.7", only: :test}
    ]
  end
end
