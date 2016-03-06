defmodule Webpay.Customer do
  defstruct [:id, {:object, "customer"}, :livemode, :created, :active_card,
    :description, :recursions, :email]

  @type t :: %Webpay.Customer{}
end
