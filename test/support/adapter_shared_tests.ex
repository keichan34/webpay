defmodule Webpay.AdapterSharedTests do
  defmacro customer_create_test(adapter) do
    quote do
      {:ok, token} = unquote(adapter).token_create(card: %{
        number: "4242-4242-4242-4242",
        exp_month: "11",
        exp_year: "2017",
        cvc: "123",
        name: "EXAMPLE PERSON"
      })
      assert {:ok, customer} = unquote(adapter).customer_create(email: "customer@example.com", card: token.id)
      assert %Webpay.Customer{} = customer
      assert %Webpay.Card{} = customer.active_card
      assert customer.active_card.fingerprint == token.card.fingerprint
    end
  end

  defmacro customer_retrieve_test(adapter) do
    quote do
      {:ok, customer} = unquote(adapter).customer_create(email: "customer@example.com")
      {:ok, customer2} = unquote(adapter).customer_retrieve(customer.id)
      assert customer.id == customer2.id

      {:error, error} = unquote(adapter).customer_retrieve("cus_not_exist")
      assert %Webpay.Error{} = error
      assert error.caused_by == "missing"
      assert error.param == "id"
      assert error.type == "invalid_request_error"
    end
  end

  defmacro customer_update_test(adapter) do
    quote do
      {:ok, customer} = unquote(adapter).customer_create(email: "customer@example.com")
      {:ok, customer2} = unquote(adapter).customer_update(customer.id, email: "new_email@example.com")
      assert customer.id == customer2.id
      assert customer2.email == "new_email@example.com"
    end
  end

  defmacro customer_delete_test(adapter) do
    quote do
      {:ok, customer} = unquote(adapter).customer_create(email: "customer@example.com")
      {:ok, delete_resp} = unquote(adapter).customer_delete(customer.id)
      assert %Webpay.DeleteResponse{} = delete_resp
      assert customer.id == delete_resp.id
      assert delete_resp.deleted == true
    end
  end

  defmacro customer_all_test(adapter) do
    quote do
      {:ok, customer1} = unquote(adapter).customer_create(email: "customer_1@example.com")
      {:ok, customer2} = unquote(adapter).customer_create(email: "customer_2@example.com")

      {:ok, list} = unquote(adapter).customer_all([])
      assert Enum.any?(list.data, fn(customer) ->
        customer.id == customer1.id && customer.email == "customer_1@example.com"
      end)
      assert Enum.any?(list.data, fn(customer) ->
        customer.id == customer2.id && customer.email == "customer_2@example.com"
      end)
    end
  end

  defmacro customer_delete_active_card_test(adapter) do
    quote do
      {:ok, token} = unquote(adapter).token_create(card: %{
        number: "4242-4242-4242-4242",
        exp_month: "11",
        exp_year: "2017",
        cvc: "123",
        name: "EXAMPLE PERSON"
      })
      assert {:ok, customer} = unquote(adapter).customer_create(email: "customer@example.com", card: token.id)
      assert %Webpay.Card{} = customer.active_card

      {:ok, customer_wo_card} = unquote(adapter).customer_delete_active_card(customer.id)
      assert customer_wo_card.id == customer.id
      assert customer_wo_card.active_card == nil
    end
  end

  defmacro token_create_test(adapter) do
    quote do
      {:ok, token} = unquote(adapter).token_create(card: %{
        number: "4242-4242-4242-4242",
        exp_month: "11",
        exp_year: "2017",
        cvc: "123",
        name: "EXAMPLE PERSON"
      })
      assert %Webpay.Token{} = token
      assert %Webpay.Card{} = token.card

      {:ok, retrieved_token} = unquote(adapter).token_retrieve(token.id)
      assert retrieved_token.id == token.id
      assert retrieved_token.card.fingerprint == token.card.fingerprint
    end
  end

  defmacro recursion_create_test(adapter) do
    quote do
      {:ok, token} = unquote(adapter).token_create(card: %{
        number: "4242-4242-4242-4242",
        exp_month: "11",
        exp_year: "2017",
        cvc: "123",
        name: "EXAMPLE PERSON"
      })
      {:ok, customer} = unquote(adapter).customer_create(
        email: "customer@example.com",
        card: token.id)
      {:ok, recursion} = unquote(adapter).recursion_create(
        customer: customer.id,
        amount: 100,
        currency: "jpy",
        period: "month")
      assert %Webpay.Recursion{} = recursion

      {:ok, recursion2} = unquote(adapter).recursion_retrieve(recursion.id)
      assert recursion2.id == recursion.id
    end
  end

  defmacro account_retrieve_test(adapter) do
    quote do
      {:ok, account} = unquote(adapter).account_retrieve
      assert %Webpay.Account{} = account
    end
  end

  defmacro account_delete_data_test(adapter) do
    quote do
      {:ok, customer} = unquote(adapter).customer_create(email: "customer@example.com")

      {:ok, delete_resp} = unquote(adapter).account_delete_data
      assert %Webpay.DeleteResponse{} = delete_resp

      {:error, error} = unquote(adapter).customer_retrieve("cus_not_exist")
      assert %Webpay.Error{} = error
      assert error.caused_by == "missing"
      assert error.param == "id"
      assert error.type == "invalid_request_error"
    end
  end
end
