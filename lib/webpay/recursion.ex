defmodule Webpay.Recursion do
  defstruct [:id, :object, :livemode, :created, :amount, :currency, :period,
    :description, :customer, :shop, :last_executed, :next_scheduled, :status,
    :deleted]

  @type t :: %Webpay.Recursion{}
end
