defmodule Webpay.List do
  defstruct [{:object, "list"}, :url, :count, :data]

  @type t :: %Webpay.List{}
end
