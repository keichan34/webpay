defmodule Webpay.Error do
  defstruct [:message, :type, :caused_by, :code, :param, :charge]

  @type t :: %Webpay.Error{}
end
