# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit
# Derived from: https://github.com/tidewave-ai/tidewave_phoenix (lib/tidewave/router.ex) tidewave v0.5.5
# Modifications: module renamed to Corex.MCP.Router; private key :corex_mcp_config; Corex
#   landing HTML, JSON /config, client metadata; no Tidewave team/tidewave_version fields.

defmodule Corex.MCP.Router do
  @moduledoc false

  use Plug.Router
  import Plug.Conn
  require Logger
  alias Corex.Json
  alias Corex.MCP.Server

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
    Logger.metadata(tidewave_mcp: true)

    # For GET requests, return 405 Method Not Allowed
    # (Corex doesn't need to support SSE streaming)
    conn
    |> send_resp(405, "Method Not Allowed")
    |> halt()
  end

  post "/mcp" do
    Logger.metadata(tidewave_mcp: true)

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
    # Return 404 for /.well-known resources lookup and similar
    Logger.metadata(tidewave_mcp: true)

    conn
    |> send_resp(404, "Not Found")
    |> halt()
  end

  defp check_remote_ip(conn, _opts) do
    cond do
      is_local?(conn.remote_ip) ->
        conn

      conn.private.corex_mcp_config.allow_remote_access ->
        conn

      true ->
        log_and_send_403(conn, """
        For security reasons, Corex.MCP does not accept remote connections by default.

        If you need remote access, configure plug Corex.MCP with allow_remote_access: true.
        """)
    end
  end

  defp is_local?({127, 0, 0, _}), do: true
  defp is_local?({0, 0, 0, 0, 0, 0, 0, 1}), do: true
  # ipv4 mapped ipv6 address ::ffff:127.0.0.1
  defp is_local?({0, 0, 0, 0, 0, 65_535, 32_512, 1}), do: true
  defp is_local?(_), do: false

  defp check_origin(conn, _opts) do
    case {conn.path_info, get_req_header(conn, "origin")} do
      {[], _} ->
        conn

      {_, []} ->
        conn

      {_, _} ->
        log_and_send_403(conn, """
        For security reasons, Corex.MCP does not accept requests with an origin header for this endpoint.
        """)
    end
  end

  defp log_and_send_403(conn, message) do
    Logger.warning(message)

    conn
    |> send_resp(403, message)
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

  defp config(plug_config) do
    %{
      name: "corex",
      framework_type: "phoenix",
      corex_version: package_version(:corex),
      allow_remote_access: plug_config.allow_remote_access
    }
  end
end
