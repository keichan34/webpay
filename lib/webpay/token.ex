defmodule Webpay.Token do
  defstruct [:id, :object, :livemode, :created, :used, :card]

  @type t :: %Webpay.Token{}
end
