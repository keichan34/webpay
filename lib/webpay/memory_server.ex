defmodule Webpay.MemoryServer do
  @moduledoc false

  use GenServer

  alias Webpay.{Card, Customer, List, Token}

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{
      customers: %{},
      tokens: %{}
    }}
  end

  def handle_call({:customer_create, params}, _from, state) do
    active_card = case Map.fetch(params, :card) do
      {:ok, ("tok_" <> _) = token} ->
        case Map.fetch(state.tokens, token) do
          {:ok, token} ->
            token.card
          _ ->
            nil
        end
      _ -> nil
    end

    customer = %Customer{id: make_id("cus")}
    |> Map.merge(Map.take(params, [:email, :description]))
    |> Map.put(:created, current_time)
    |> Map.put(:active_card, active_card)
    state = put_in(state.customers[customer.id], customer)
    {:reply, {:ok, customer}, state}
  end

  def handle_call({:customer_retrieve, id}, _, state) do
    customer = Map.get(state.customers, id)
    {:reply, {:ok, customer}, state}
  end

  def handle_call({:customer_update, {id, params}}, _, state) do
    customer = Map.get(state.customers, id)
    |> Map.merge(Map.take(params, [:email, :description]))

    customer = case Map.fetch(params, :card) do
      {:ok, ("tok_" <> _) = token} ->
        case Map.fetch(state.tokens, token) do
          {:ok, token} ->
            Map.put(customer, :active_card, token.card)
          _ ->
            customer
        end
      _ -> customer
    end

    state = put_in(state.customers[customer.id], customer)
    {:reply, {:ok, customer}, state}
  end

  def handle_call({:customer_delete, id}, _, state) do
    state = update_in(state.customers, &Map.delete(&1, id))
    {:reply, {:ok, %{"id" => id, "deleted" => true}}, state}
  end

  def handle_call({:customer_all, {}}, _, state) do
    customers = Enum.map(state.customers, fn({_key, value}) -> value end)
    {:reply, {:ok, %List{
      count: length(customers),
      data: customers
    }}, state}
  end

  def handle_call({:customer_delete_active_card, id}, _, state) do
    customer = Map.get(state.customers, id)
    |> Map.put(:active_card, nil)
    state = put_in(state.customers[customer.id], customer)
    {:reply, {:ok, customer}, state}
  end

  def handle_call({:token_create, %{card: card_params}}, _from, state) do
    token = %Token{
      id: make_id("tok"),
      livemode: false,
      created: current_time,
      used: false,
      card: card_from_params(card_params)
    }
    state = put_in(state.tokens[token.id], token)
    {:reply, {:ok, token}, state}
  end

  def handle_call({:token_retrieve, id}, _, state) do
    token = Map.get(state.tokens, id)
    {:reply, {:ok, token}, state}
  end

  defp make_id(type) do
    type <> "_" <> (:crypto.strong_rand_bytes(15) |> Base.url_encode64 |> binary_part(0, 15))
  end

  defp md5_hash(data),
    do: :crypto.hash(:md5, data) |> Base.hex_encode32(case: :lower)

  defp current_time,
    do: :erlang.system_time(:seconds)

  defp card_from_params(params) do
    card_number = Regex.replace(~r/[^0-9]/, params.number, "")
    {_, last4} = String.split_at(card_number, -4)
    card = %Card{}
    |> Map.merge(params)
    |> Map.put(:cvc_check, "pass")
    |> Map.put(:fingerprint, md5_hash(card_number))
    |> Map.put(:last4, last4)
  end
end
