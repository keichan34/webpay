defmodule Webpay do
  use Application

  @compile {:inline, adapter: 0}

  def adapter,
    do: Application.get_env(:webpay, :adapter, Webpay.Adapter.HTTPoison)

  def secret_key do
    Application.get_env(:webpay, :credentials, [])
    |> Keyword.fetch!(:secret_key)
  end

  def start(_type, _args) do
    Webpay.Supervisor.start_link
  end
end
