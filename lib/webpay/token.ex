defmodule Webpay.Token do
  defstruct [:id, {:object, "token"}, :livemode, :created, :used, :card]

  @type t :: %Webpay.Token{}
end
