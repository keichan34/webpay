# Webpay

[![Build Status](https://travis-ci.org/keichan34/webpay.svg?branch=master)](https://travis-ci.org/keichan34/webpay)

**Warning!** This is pre-release, work-in-progress, alpha grade material.

An interface to [WebPay](https://webpay.jp) for Elixir.

This library is not sponsored or supported by WebPay in any way. Please use it
at your own risk. I encourage you to review the code and test suite before using.

## Installation

  1. Add webpay to your list of dependencies in `mix.exs`:

        def deps do
          [{:webpay, "~> 0.0.1"}]
        end

  2. Ensure webpay is started before your application:

        def application do
          [applications: [:webpay]]
        end

  3. Configure Webpay in `config.exs` (or environment equivalent):

        config :webpay, :adapter, Webpay.Adapter.HTTPoison
        config :webpay, :credentials,
          secret_key: "secret key from WebPay",
          public_key: "public key from WebPay"

## Usage

Webpay uses pluggable adapters to provide a robust test environment without
having to rely on mocking HTTP requests.

A shortcut is provided to return the active adapter: `Webpay.adapter/0`.

To see the functions adapters implement, please see `Webpay.Adapter`.

## Example

```elixir
{:ok, token} = Webpay.adapter.token_create(card: %{
  number: "4242-4242-4242-4242",
  exp_month: "11",
  exp_year: "2017",
  cvc: "123",
  name: "EXAMPLE PERSON"
})
{:ok, customer} = Webpay.adapter.customer_create(email: "hello@example.com", card: token)
```

## Testing

A memory-based adapter is available for testing purposes without connecting to
WebPay's servers. To enable it, set the following in your `config/test.exs`:

```elixir
config :webpay, :adapter, Webpay.Adapter.Memory
```

## Contributing
