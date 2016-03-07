defmodule Webpay.Adapter.HTTPoison do
  @behaviour Webpay.Adapter

  alias Webpay.Adapter.HTTPoison.ResponseParser

  @uri_base "https://api.webpay.jp/v1"

  def customer_create(params),
    do: request(:post, "/customers", params)
  def customer_retrieve(id),
    do: request(:get, "/customers/" <> id)
  def customer_update(id, params),
    do: request(:post, "/customers/" <> id, params)
  def customer_delete(id),
    do: request(:delete, "/customers/" <> id)
  def customer_all(params),
    do: request(:get, {"/customers", params})
  def customer_delete_active_card(id),
    do: request(:delete, "/customers/" <> id <> "/active_card")

  def token_create(params),
    do: request(:post, "/tokens", params)
  def token_retrieve(id),
    do: request(:get, "/tokens/" <> id)

  defp request(method, uri, body \\ nil, extra_headers \\ []) do
    request_headers = headers(method) ++ extra_headers
    case HTTPoison.request(method, build_uri(uri), build_body(body), request_headers) do
      {:ok, %{status_code: code, body: unparsed_body}} when code >= 200 and code < 300 ->
        {:ok, Poison.decode!(unparsed_body) |> ResponseParser.parse_response}
      {:ok, %{status_code: code, body: unparsed_body}} when code >= 400 and code < 500 ->
        handle_error(unparsed_body, code)
      {:ok, %{status_code: code, body: unparsed_body}} when code >= 500 and code < 600 ->
        handle_error(unparsed_body, code)
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp handle_error(unparsed_body, code) do
    case Poison.decode(unparsed_body) do
      {:ok, body} ->
        {:error, ResponseParser.parse_response(body)}
      {:error, _json_error} ->
        {:error, {:http_error, code, unparsed_body}}
    end
  end

  defp build_uri({path, query_params}),
    do: build_uri(path) <> "?" <> URI.encode_query(query_params)
  defp build_uri(path), do: @uri_base <> path

  defp build_body(nil), do: ""
  defp build_body(body) do
    Enum.into(body, %{}) |> Poison.encode!
  end

  defp headers(:post) do
    headers(:get) ++ [
      {"Content-Type", "application/json"}
    ]
  end

  defp headers(_) do
    [
      {"Accept", "application/json"},
      {"Authorization", authorization_header_contents},
      {"User-Agent", "Webpay Elixir Client v0.0.1"},
      {"Accept-Language", "en"}
    ]
  end

  defp authorization_header_contents do
    "Basic " <> Base.encode64(Webpay.secret_key <> ":")
  end
end
