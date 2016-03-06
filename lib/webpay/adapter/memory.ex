defmodule Webpay.Adapter.Memory do
  @moduledoc """
  An in-memory adapter for testing purposes.
  """

  @behaviour Webpay.Adapter

  def customer_create(params),
    do: request(:customer_create, ltm(params))
  def customer_retrieve(id),
    do: request(:customer_retrieve, id)
  def customer_update(id, params),
    do: request(:customer_update, {id, ltm(params)})
  def customer_delete(id),
    do: request(:customer_delete, id)
  def customer_all(_),
    do: request(:customer_all, {})
  def customer_delete_active_card(id),
    do: request(:customer_delete_active_card, id)

  def token_create(params),
    do: request(:token_create, ltm(params))
  def token_retrieve(id),
    do: request(:token_retrieve, id)

  # List To Map
  defp ltm(enum), do: Enum.into(enum, %{})

  defp request(name, argv) do
    GenServer.call(Webpay.MemoryServer, {name, argv})
  end
end
