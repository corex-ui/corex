# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit
# See LICENSE for third-party notices.

defmodule Corex.MCP.Router do
  @moduledoc false

  use Plug.Router
  import Plug.Conn
  require Logger
  alias Corex.Json
  alias Corex.MCP.Server

  @remote_access_forbidden """
  For security reasons, Corex.MCP does not accept remote connections by default.

  If you really want to allow remote connections, configure plug Corex.MCP with allow_remote_access: true.
  """

  @origin_header_forbidden """
  For security reasons, Corex.MCP does not accept requests with an origin header for this endpoint.
  """

  plug(:match)
  plug(:check_remote_ip)
  plug(:check_origin)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, corex_mcp_html())
    |> halt()
  end

  get "/config" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Json.encode_to_iodata!(config(conn.private.corex_mcp_config)))
    |> halt()
  end

  get "/mcp" do
    Logger.metadata(corex_mcp: true)

    conn
    |> send_resp(405, "Method Not Allowed")
    |> halt()
  end

  post "/mcp" do
    Logger.metadata(corex_mcp: true)

    opts =
      Plug.Parsers.init(
        parsers: [:json],
        pass: [],
        json_decoder: Json.encoder()
      )

    conn
    |> Plug.Parsers.call(opts)
    |> Server.handle_http_message()
    |> halt()
  end

  match "/*_ignored" do
    Logger.metadata(corex_mcp: true)

    conn
    |> send_resp(404, "Not Found")
    |> halt()
  end

  defp check_remote_ip(conn, _opts) do
    cond do
      loopback_address?(conn.remote_ip) ->
        conn

      conn.private.corex_mcp_config.allow_remote_access ->
        conn

      true ->
        deny_remote_access(conn)
    end
  end

  defp loopback_address?({127, 0, 0, _}), do: true
  defp loopback_address?({0, 0, 0, 0, 0, 0, 0, 1}), do: true
  defp loopback_address?({0, 0, 0, 0, 0, 65_535, 32_512, 1}), do: true
  defp loopback_address?(_), do: false

  defp check_origin(conn, _opts) do
    case {conn.path_info, get_req_header(conn, "origin")} do
      {[], _} ->
        conn

      {_, []} ->
        conn

      {_, _} ->
        deny_origin_header(conn)
    end
  end

  defp deny_remote_access(conn) do
    Logger.warning(@remote_access_forbidden)

    conn
    |> send_resp(403, @remote_access_forbidden)
    |> halt()
  end

  defp deny_origin_header(conn) do
    Logger.warning(@origin_header_forbidden)

    conn
    |> send_resp(403, @origin_header_forbidden)
    |> halt()
  end

  defp corex_mcp_html do
    """
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Corex MCP</title>
      </head>
      <body>
        <p>Corex Model Context Protocol (dev). Use POST to <code>/corex/mcp</code> for JSON-RPC.</p>
      </body>
    </html>
    """
  end

  defp package_version(app) do
    if vsn = Application.spec(app)[:vsn] do
      List.to_string(vsn)
    end
  end

  defp config(_plug_config) do
    %{
      name: "corex",
      framework_type: "phoenix",
      corex_version: package_version(:corex)
    }
  end
end
