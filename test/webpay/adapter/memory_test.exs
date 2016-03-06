defmodule Webpay.Adapter.MemoryTest do
  use ExUnit.Case, async: true

  import Webpay.AdapterSharedTests
  alias Webpay.Adapter.Memory, as: Adapter

  test "customer_create/1" do
    customer_create_test(Adapter)
  end

  test "customer_retrieve/1" do
    customer_retrieve_test(Adapter)
  end

  test "customer_update/2" do
    customer_update_test(Adapter)
  end

  test "customer_delete/1" do
    customer_delete_test(Adapter)
  end

  test "customer_all/1" do
    customer_all_test(Adapter)
  end

  test "customer_delete_active_card/1" do
    customer_delete_active_card_test(Adapter)
  end

  test "token_create/1 and token_retrieve/1" do
    token_create_test(Adapter)
  end
end
