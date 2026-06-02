# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit
# See LICENSE for third-party notices.
# Upstream: tidewave v0.5.6 (deps/tidewave/lib/tidewave/mcp/server.ex)
# Modifications: Corex.MCP namespace; Corex.MCP.Tools.*; Corex serverInfo;
#   tools stored in :persistent_term, initialized from plug init/1.

defmodule Corex.MCP.Server do
  @moduledoc false

  require Logger
  import Plug.Conn

  alias Corex.MCP.Tools.Components, as: McpToolComponents
  alias Corex.MCP.Tools.Installation, as: McpToolInstallation

  @protocol_version "2025-03-26"
  @vsn Mix.Project.config()[:version] || "0.0.0"
  @tools_key {__MODULE__, :tools_and_dispatch}

  @parse_error -32_600
  @method_not_found -32_601
  @invalid_params -32_602

  @doc "Loads tool specs and callbacks into persistent term storage."
  def init_tools do
    tools =
      [McpToolComponents.tools(), McpToolInstallation.tools()]
      |> Enum.flat_map(& &1)

    dispatch = Map.new(tools, &{&1.name, &1.callback})
    :persistent_term.put(@tools_key, {tools, dispatch})
    :ok
  end

  @doc "Returns the stored `{tools, dispatch}` tuple."
  def tools_and_dispatch do
    :persistent_term.get(@tools_key)
  end

  defp tools do
    {tools, _dispatch} = tools_and_dispatch()

    for tool <- tools do
      tool
      |> Map.put(:description, String.trim(tool.description))
      |> Map.drop([:callback])
    end
  end

  defp dispatch(name, args, assigns) do
    {_tools, dispatch} = tools_and_dispatch()

    case dispatch do
      %{^name => callback} when is_function(callback, 2) ->
        callback.(args, assigns)

      %{^name => callback} when is_function(callback, 1) ->
        callback.(args)

      _ ->
        {:error,
         %{
           code: @method_not_found,
           message: "Method not found",
           data: %{name: name}
         }}
    end
  end

  defp validate_protocol_version(client_version) do
    cond do
      is_nil(client_version) ->
        {:error, "Protocol version is required"}

      client_version < @protocol_version ->
        {:error, "Unsupported protocol version. Server supports #{@protocol_version} or later"}

      true ->
        :ok
    end
  end

  defp handle_ping(request_id) do
    jsonrpc_result(request_id, %{})
  end

  defp handle_initialize(request_id, params) do
    case validate_protocol_version(params["protocolVersion"]) do
      :ok ->
        jsonrpc_result(request_id, %{
          protocolVersion: @protocol_version,
          capabilities: %{tools: %{listChanged: false}},
          serverInfo: %{name: "Corex MCP", version: to_string(@vsn)},
          tools: tools()
        })

      {:error, reason} ->
        {:error,
         %{
           jsonrpc: "2.0",
           id: request_id,
           error: %{code: @invalid_params, message: reason}
         }}
    end
  end

  defp handle_list_tools(request_id, _params) do
    result_or_error(request_id, {:ok, %{tools: tools()}})
  end

  defp handle_list_prompts(request_id, _params) do
    result_or_error(request_id, {:ok, %{prompts: []}})
  end

  defp handle_list_resources(request_id, _params) do
    result_or_error(request_id, {:ok, %{resources: []}})
  end

  defp handle_list_templates(request_id, _params) do
    result_or_error(request_id, {:ok, %{templates: []}})
  end

  defp jsonrpc_result(request_id, result) do
    {:ok, %{jsonrpc: "2.0", id: request_id, result: result}}
  end

  defp result_or_error(request_id, {:ok, text, metadata})
       when is_binary(text) and is_map(metadata) do
    result_or_error(request_id, {:ok, %{content: [%{type: "text", text: text}], _meta: metadata}})
  end

  defp result_or_error(request_id, {:ok, text}) when is_binary(text) do
    result_or_error(request_id, {:ok, %{content: [%{type: "text", text: text}]}})
  end

  defp result_or_error(request_id, {:ok, result}) when is_map(result) do
    jsonrpc_result(request_id, result)
  end

  defp result_or_error(request_id, {:error, :invalid_arguments}) do
    {:error,
     %{
       jsonrpc: "2.0",
       id: request_id,
       error: %{code: @invalid_params, message: "Invalid arguments for tool"}
     }}
  end

  defp result_or_error(request_id, {:error, message}) when is_binary(message) do
    result_or_error(
      request_id,
      {:ok, %{content: [%{type: "text", text: message}], isError: true}}
    )
  end

  defp result_or_error(request_id, {:error, error}) when is_map(error) do
    {:error, %{jsonrpc: "2.0", id: request_id, error: error}}
  end

  defp handle_call_tool(request_id, %{"name" => name} = params, assigns) do
    args = Map.get(params, "arguments", %{})
    result_or_error(request_id, dispatch(name, args, assigns))
  end

  defp safe_call_tool(request_id, params, assigns) do
    handle_call_tool(request_id, params, assigns)
  catch
    kind, reason ->
      {:ok,
       %{
         jsonrpc: "2.0",
         id: request_id,
         result: %{
           content: [
             %{
               type: "text",
               text: "Failed to call tool: #{Exception.format(kind, reason, __STACKTRACE__)}"
             }
           ],
           isError: true
         }
       }}
  end

  defp handle_message(%{"method" => "notifications/initialized"} = message, _assigns) do
    Logger.info("Received initialized notification")
    Logger.debug("Full message: #{inspect(message, pretty: true)}")
    {:ok, nil}
  end

  defp handle_message(%{"method" => "notifications/cancelled"} = message, _assigns) do
    Logger.info("Request cancelled: #{inspect(message["params"])}")
    {:ok, nil}
  end

  defp handle_message(%{"method" => method, "id" => id} = message, assigns) do
    Logger.info("Routing MCP message - Method: #{method}, ID: #{id}")
    Logger.debug("Full message: #{inspect(message, pretty: true)}")
    route_request(method, id, message, assigns)
  end

  defp route_request("ping", id, _message, _assigns), do: handle_ping(id)

  defp route_request("initialize", id, message, _assigns) do
    handle_initialize(id, message["params"] || %{})
  end

  defp route_request("tools/list", id, message, _assigns) do
    handle_list_tools(id, message["params"])
  end

  defp route_request("tools/call", id, message, assigns) do
    safe_call_tool(id, message["params"], assigns)
  end

  defp route_request("prompts/list", id, message, _assigns) do
    handle_list_prompts(id, message["params"])
  end

  defp route_request("resources/list", id, message, _assigns) do
    handle_list_resources(id, message["params"])
  end

  defp route_request("resources/templates/list", id, message, _assigns) do
    handle_list_templates(id, message["params"])
  end

  defp route_request(other, id, _message, _assigns) do
    Logger.warning("Received unsupported method: #{other}")

    {:error,
     %{
       jsonrpc: "2.0",
       id: id,
       error: %{code: @method_not_found, message: "Method not found", data: %{name: other}}
     }}
  end

  defp validate_jsonrpc_message(%{"jsonrpc" => "2.0"} = message) do
    cond do
      Map.has_key?(message, "id") and Map.has_key?(message, "method") ->
        valid_request_id?(message["id"], message)

      not Map.has_key?(message, "id") and Map.has_key?(message, "method") ->
        {:ok, message}

      Map.has_key?(message, "id") and Map.has_key?(message, "result") ->
        {:ok, message}

      true ->
        {:error, :invalid_jsonrpc}
    end
  end

  defp validate_jsonrpc_message(_), do: {:error, :invalid_jsonrpc}

  defp valid_request_id?(id, message) when is_binary(id) or is_number(id), do: {:ok, message}
  defp valid_request_id?(_, _), do: {:error, :invalid_jsonrpc}

  defp send_json(conn, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status || 200, Corex.Json.encode!(data))
  end

  defp send_jsonrpc_error(conn, id, code, message, data \\ nil) do
    error =
      %{code: code, message: message}
      |> maybe_put_error_data(data)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Corex.Json.encode!(%{jsonrpc: "2.0", id: id, error: error}))
  end

  defp maybe_put_error_data(error, nil), do: error
  defp maybe_put_error_data(error, data), do: Map.put(error, :data, data)

  @doc "Handles a JSON-RPC MCP request over HTTP."
  def handle_http_message(conn) do
    Logger.info("Received #{conn.method} message")
    params = conn.body_params
    conn = fetch_query_params(conn)
    Logger.debug("Raw params: #{inspect(params, pretty: true)}")

    with {:ok, message} <- validate_jsonrpc_message(params),
         {:ok, response} <- handle_message(message, conn.private.corex_mcp_config) do
      case response do
        nil ->
          conn |> put_status(202) |> send_json(%{status: "ok"})

        response ->
          Logger.debug("Sending HTTP response: #{inspect(response, pretty: true)}")
          conn |> put_status(200) |> send_json(response)
      end
    else
      {:error, :invalid_jsonrpc} ->
        Logger.warning("Invalid JSON-RPC message format")
        send_jsonrpc_error(conn, nil, @parse_error, "Could not parse message")

      {:error, error_response} when is_map(error_response) ->
        Logger.warning("Error handling message: #{inspect(error_response)}")
        conn |> put_status(400) |> send_json(error_response)
    end
  end
end
