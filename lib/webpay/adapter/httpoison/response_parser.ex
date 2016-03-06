defmodule Webpay.Adapter.HTTPoison.ResponseParserGenerator do
  @moduledoc false

  defmacro object_parser(object_name, tmpl) do
    quote do
      def parse_response(%{"object" => unquote(object_name)} = response) do
        Enum.reduce response, unquote(tmpl), fn({key, value}, acc) ->
          Map.put acc, String.to_existing_atom(key), parse_response(value)
        end
      end
    end
  end
end

defmodule Webpay.Adapter.HTTPoison.ResponseParser do
  @moduledoc false

  alias Webpay.{Customer, Card, Recursion, Token, List}

  import Webpay.Adapter.HTTPoison.ResponseParserGenerator

  object_parser "customer", %Customer{}
  object_parser "card", %Card{}
  object_parser "recursion", %Recursion{}
  object_parser "token", %Token{}
  object_parser "list", %List{}

  def parse_response(list) when is_list(list),
    do: Enum.map(list, &parse_response/1)
  def parse_response(other),
    do: other
end
