defmodule Webpay.List do
  defstruct [:object, :url, :count, :data]

  @type t :: %Webpay.List{}
end
