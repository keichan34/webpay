defmodule Webpay.Card do
  defstruct [:object, :exp_month, :exp_year, :fingerprint, :last4, :type,
    :cvc_check, :name, :country]

  @type t :: %Webpay.Card{}
end
