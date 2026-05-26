defmodule Corex.Integration.HttpSmoke do
  @moduledoc false

  def dev_database_env_from_system do
    Enum.flat_map(
      ~w(DATABASE_URL PGHOST PGUSER PGPASSWORD PGPORT PGDATABASE),
      fn key ->
        case System.get_env(key) do
          nil -> []
          val -> [{key, val}]
        end
      end
    )
  end

  def request_with_retries(_url, 0), do: {:error, :out_of_retries}

  def request_with_retries(url, retries) do
    url = String.replace(url, "://localhost", "://127.0.0.1")

    case http_request(url) do
      {:ok, {{_, status_code, _}, raw_headers, body}} when status_code >= 500 ->
        if retries > 1 do
          Process.sleep(2_000)
          request_with_retries(url, retries - 1)
        else
          {:ok,
           %{
             status_code: status_code,
             headers: for({k, v} <- raw_headers, do: {to_string(k), to_string(v)}),
             body: to_string(body)
           }}
        end

      {:ok, httpc_response} ->
        {{_, status_code, _}, raw_headers, body} = httpc_response

        {:ok,
         %{
           status_code: status_code,
           headers: for({k, v} <- raw_headers, do: {to_string(k), to_string(v)}),
           body: to_string(body)
         }}

      {:error, {:failed_connect, _}} ->
        Process.sleep(2_000)
        request_with_retries(url, retries - 1)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp http_request(url) do
    :telemetry.span(
      [:integration, :http, :request],
      %{url: url},
      fn ->
        result = url |> to_charlist() |> :httpc.request()

        metadata =
          case result do
            {:ok, {{_, status, _}, _, _}} -> %{status: status}
            {:error, _} -> %{status: :error}
          end

        {result, metadata}
      end
    )
  end
end
