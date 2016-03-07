use Mix.Config

config :webpay, :adapter, Webpay.Adapter.HTTPoison
# config :webpay, :credentials,
#   secret_key: "test_secret_XXX",
#   public_key: "test_public_XXX"

if File.exists?("./config/dev.secret.exs") do
  import_config "dev.secret.exs"
end
