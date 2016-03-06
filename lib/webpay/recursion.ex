defmodule Webpay.Recursion do
  defstruct [:id, {:object, "recursion"}, :livemode, :created, :amount,
    :currency, :period, :description, :customer, :shop, :last_executed,
    :next_scheduled, :status, :deleted]

  @type t :: %Webpay.Recursion{}
end
