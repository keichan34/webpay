use Mix.Config

# The HTTPoison adapter is the default adapter.
config :webpay, :adapter, Webpay.Adapter.HTTPoison

import_config "#{Mix.env}.exs"
