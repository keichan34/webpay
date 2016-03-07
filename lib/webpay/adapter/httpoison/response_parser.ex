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

  alias Webpay.{Account, Customer, Card, Error, Recursion, Token, List,
    DeleteResponse}

  import Webpay.Adapter.HTTPoison.ResponseParserGenerator

  def parse_response(%{"error" => error_params}) do
    Enum.reduce error_params, %Error{}, fn({key, value}, acc) ->
      Map.put acc, String.to_existing_atom(key), value
    end
  end

  def parse_response(%{"deleted" => true} = params) do
    Enum.reduce params, %DeleteResponse{}, fn({key, value}, acc) ->
      Map.put acc, String.to_existing_atom(key), value
    end
  end

  object_parser "account", %Account{}
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
