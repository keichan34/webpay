defmodule Webpay.Adapter.HTTPoisonTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import Webpay.AdapterSharedTests
  alias Webpay.Adapter.HTTPoison, as: Adapter

  setup_all do
    HTTPoison.start
  end

  test "customer_create/1" do
    use_cassette "customer_create" do
      customer_create_test(Adapter)
    end
  end

  test "customer_retrieve/1" do
    use_cassette "customer_retrieve" do
      customer_retrieve_test(Adapter)
    end
  end

  test "customer_update/2" do
    use_cassette "customer_update" do
      customer_update_test(Adapter)
    end
  end

  test "customer_delete/1" do
    use_cassette "customer_delete" do
      customer_delete_test(Adapter)
    end
  end

  test "customer_all/1" do
    use_cassette "customer_all", match_requests_on: [:request_body] do
      customer_all_test(Adapter)
    end
  end

  test "customer_delete_active_card/1" do
    use_cassette "customer_delete_active_card" do
      customer_delete_active_card_test(Adapter)
    end
  end

  test "token_create/1 and token_retrieve/1" do
    use_cassette "token_create" do
      token_create_test(Adapter)
    end
  end

  test "recursion_create/1 and recursion_retrieve/1" do
    use_cassette "recursion_create" do
      recursion_create_test(Adapter)
    end
  end

  test "recursion_resume/2"
  test "recursion_delete/1"
  test "recursion_all/1"

  test "account_retrieve/1" do
    use_cassette "account_retrieve" do
      account_retrieve_test(Adapter)
    end
  end

  test "account_delete_data/1" do
    use_cassette "account_delete_data" do
      account_delete_data_test(Adapter)
    end
  end
end
