defmodule Webpay.Account do
  defstruct [:id, {:object, "account"}, :charge_enabled, :currencies_supported,
    :details_submitted, :email, :statement_descriptor, :card_types_supported]

  @type t :: %Webpay.Account{}
end
