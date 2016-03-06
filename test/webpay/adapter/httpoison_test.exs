defmodule Webpay.Adapter.HTTPoisonTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Webpay.Adapter.HTTPoison, as: A

  alias Webpay.{Card, Customer, Token}

  setup_all do
    HTTPoison.start
  end

  test "customer_create/1" do
    use_cassette "customer_create" do
      {:ok, token} = A.token_create(card: %{
        number: "4242-4242-4242-4242",
        exp_month: "11",
        exp_year: "2017",
        cvc: "123",
        name: "EXAMPLE PERSON"
      })
      assert {:ok, customer} = A.customer_create(email: "customer@example.com", card: token.id)
      assert %Customer{} = customer
      assert %Card{} = customer.active_card
      assert customer.active_card.fingerprint == token.card.fingerprint
    end
  end

  test "customer_retrieve/1" do
    use_cassette "customer_retrieve" do
      {:ok, customer} = A.customer_create(email: "customer@example.com")
      {:ok, customer2} = A.customer_retrieve(customer.id)
      assert customer.id == customer2.id
    end
  end

  test "customer_update/2" do
    use_cassette "customer_update" do
      {:ok, customer} = A.customer_create(email: "customer@example.com")
      {:ok, customer2} = A.customer_update(customer.id, email: "new_email@example.com")
      assert customer.id == customer2.id
      assert customer2.email == "new_email@example.com"
    end
  end

  test "customer_delete/1" do
    use_cassette "customer_delete" do
      {:ok, customer} = A.customer_create(email: "customer@example.com")
      {:ok, customer2} = A.customer_delete(customer.id)
      assert customer.id == customer2["id"]
      assert customer2["deleted"] == true
    end
  end

  test "customer_all/1" do
    use_cassette "customer_all", match_requests_on: [:request_body] do
      {:ok, customer1} = A.customer_create(email: "customer_1@example.com")
      {:ok, customer2} = A.customer_create(email: "customer_2@example.com")

      {:ok, list} = A.customer_all([])
      assert Enum.any?(list.data, fn(customer) ->
        customer.id == customer1.id && customer.email == "customer_1@example.com"
      end)
      assert Enum.any?(list.data, fn(customer) ->
        customer.id == customer2.id && customer.email == "customer_2@example.com"
      end)
    end
  end

  test "customer_delete_active_card/1" do
    use_cassette "customer_delete_active_card" do
      {:ok, token} = A.token_create(card: %{
        number: "4242-4242-4242-4242",
        exp_month: "11",
        exp_year: "2017",
        cvc: "123",
        name: "EXAMPLE PERSON"
      })
      assert {:ok, customer} = A.customer_create(email: "customer@example.com", card: token.id)
      assert %Card{} = customer.active_card

      {:ok, customer_wo_card} = A.customer_delete_active_card(customer.id)
      assert customer_wo_card.id == customer.id
      assert customer_wo_card.active_card == nil
    end
  end

  test "token_create/1 and token_retrieve/1" do
    use_cassette "token_create" do
      {:ok, token} = A.token_create(card: %{
        number: "4242-4242-4242-4242",
        exp_month: "11",
        exp_year: "2017",
        cvc: "123",
        name: "EXAMPLE PERSON"
      })
      assert %Token{} = token
      assert %Card{} = token.card

      {:ok, retrieved_token} = A.token_retrieve(token.id)
      assert retrieved_token.id == token.id
      assert retrieved_token.card.fingerprint == token.card.fingerprint
    end
  end
end
