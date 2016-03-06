use Mix.Config

config :webpay, :adapter, Webpay.Adapter.Memory

config :webpay, :credentials,
  secret_key: "secret",
  public_key: "public"

config :exvcr,
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  custom_cassette_library_dir: "fixture/custom_cassettes",
  filter_sensitive_data: [
    [pattern: "Basic [a-zA-Z0-9+/=]+", placeholder: "Basic c2VjcmV0Og=="]
  ],
  filter_url_params: false,
  response_headers_blacklist: [
    "Cache-Control",
    "Server",
    "Strict-Transport-Security",
    "X-Content-Type-Options",
    "X-Frame-Options",
    "X-Rack-Cache",
    "X-Request-Id",
    "X-Runtime",
    "X-UA-Compatible",
    "X-XSS-Protection",
  ]
