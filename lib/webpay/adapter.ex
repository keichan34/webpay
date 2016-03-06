defmodule Webpay.Adapter do
  @moduledoc """
  A behaviour defining the API an adapter should adhere to.

  You shouldn't need to access this module manually, since it doesn't have any
  exported functions, but it has the documentation for all the functions that
  each adapter uses.
  """

  alias Webpay.{Customer, Token}

  @type reason :: atom

  @type id :: String.t
  @type params :: [...]

  # Customer
  @type customer_response :: {:ok, Customer.t} | {:error, reason}

  @callback customer_create(params) :: customer_response
  @callback customer_retrieve(id) :: customer_response
  @callback customer_update(id, params) :: customer_response
  @callback customer_delete(id) :: customer_response
  @callback customer_all(params) :: {:ok, [Customer.t, ...]} | {:error, reason}
  @callback customer_delete_active_card(id) :: customer_response

  # Token
  @type token_response :: {:ok, Token.t} | {:error, reason}

  @callback token_create(params) :: token_response
  @callback token_retrieve(id) :: token_response
end
