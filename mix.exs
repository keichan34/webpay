defmodule Webpay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :webpay,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      source_url: "https://github.com/keichan34/webpay",
      docs: [
        extras: ["README.md"]
      ],
      package: package,
      description: description,
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:httpoison, "~> 0.8.1"},
      {:poison, "~> 2.1"},
      {:exvcr, "~> 0.7", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.txt"],
      maintainers: ["Keitaroh Kobayashi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/keichan34/webpay",
        "Docs" => "http://hexdocs.pm/webpay/readme.html"
      }
    ]
  end

  defp description do
    """
    An interface to the WebPay payment processor for Elixir.
    """
  end
end
