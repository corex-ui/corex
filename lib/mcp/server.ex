# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit
# Derived from: https://github.com/tidewave-ai/tidewave_phoenix (lib/tidewave/mcp/server.ex) tidewave v0.5.5
# Modifications: Corex.MCP namespace; ETS :corex_mcp_tools; Corex.MCP.Tools.*; Corex
#   serverInfo; init_tools is idempotent (lazy) when not started from the host app.

defmodule Corex.MCP.Server do
  @moduledoc false
  require Logger
  import Plug.Conn

  @protocol_version "2025-03-26"
  @vsn Mix.Project.config()[:version] || "0.0.0"

  defp mcp_verbose? do
    System.get_env("COREX_MCP_VERBOSE") in ~w(1 true yes)
  end

  defp mcp_debug(message) do
    if mcp_verbose?(), do: Logger.debug(message)
  end

  defp raw_tools do
    [
      Corex.MCP.Tools.Components.tools()
    ]
    |> List.flatten()
  end

  @doc false
  def init_tools do
    if :ets.whereis(:corex_mcp_tools) == :undefined do
      tools = raw_tools()
      dispatch_map = Map.new(tools, fn tool -> {tool.name, tool.callback} end)
      :ets.new(:corex_mcp_tools, [:set, :named_table, read_concurrency: true])
      :ets.insert(:corex_mcp_tools, {:tools, {tools, dispatch_map}})
    end

    :ok
  end

  @doc false
  def tools_and_dispatch do
    [{:tools, tools}] = :ets.lookup(:corex_mcp_tools, :tools)
    tools
  end

  defp tools do
    {tools, _} = tools_and_dispatch()

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
           code: -32601,
           message: "Method not found",
           data: %{
             name: name
           }
         }}
    end
  end

  defp validate_protocol_version(client_version) do
    cond do
      is_nil(client_version) ->
        {:error, "Protocol version is required"}

      client_version < unquote(@protocol_version) ->
        {:error,
         "Unsupported protocol version. Server supports #{unquote(@protocol_version)} or later"}

      true ->
        :ok
    end
  end

  defp handle_ping(request_id) do
    {:ok,
     %{
       jsonrpc: "2.0",
       id: request_id,
       result: %{}
     }}
  end

  defp handle_initialize(request_id, params) do
    case validate_protocol_version(params["protocolVersion"]) do
      :ok ->
        {:ok,
         %{
           jsonrpc: "2.0",
           id: request_id,
           result: %{
             protocolVersion: unquote(@protocol_version),
             capabilities: %{
               tools: %{
                 listChanged: false
               }
             },
             serverInfo: %{
               name: "Corex MCP",
               version: to_string(@vsn)
             },
             tools: tools()
           }
         }}

      {:error, reason} ->
        {:error, reason}
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

  defp result_or_error(request_id, {:ok, text, metadata})
       when is_binary(text) and is_map(metadata) do
    result_or_error(request_id, {:ok, %{content: [%{type: "text", text: text}], _meta: metadata}})
  end

  defp result_or_error(request_id, {:ok, text}) when is_binary(text) do
    result_or_error(request_id, {:ok, %{content: [%{type: "text", text: text}]}})
  end

  defp result_or_error(request_id, {:ok, result}) when is_map(result) do
    {:ok,
     %{
       jsonrpc: "2.0",
       id: request_id,
       result: result
     }}
  end

  defp result_or_error(request_id, {:error, :invalid_arguments}) do
    {:error,
     %{
       jsonrpc: "2.0",
       id: request_id,
       error: %{code: -32602, message: "Invalid arguments for tool"}
     }}
  end

  defp result_or_error(request_id, {:error, message}) when is_binary(message) do
    result_or_error(
      request_id,
      {:ok, %{content: [%{type: "text", text: message}], isError: true}}
    )
  end

  defp result_or_error(request_id, {:error, error}) when is_map(error) do
    {:error,
     %{
       jsonrpc: "2.0",
       id: request_id,
       error: error
     }}
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
    mcp_debug("Corex MCP notifications/initialized: #{inspect(message)}")
    {:ok, nil}
  end

  defp handle_message(%{"method" => "notifications/cancelled"} = message, _assigns) do
    mcp_debug("Corex MCP notifications/cancelled: #{inspect(message["params"])}")
    {:ok, nil}
  end

  defp handle_message(%{"method" => method, "id" => id} = message, assigns) do
    mcp_debug(
      "Corex MCP #{method} id=#{id} #{inspect(message, limit: :infinity, printable_limit: 200)}"
    )

    case method do
      "ping" ->
        mcp_debug("Corex MCP ping")
        handle_ping(id)

      "initialize" ->
        mcp_debug(
          "Corex MCP initialize params=#{inspect(message["params"], limit: 100, printable_limit: 200)}"
        )

        case handle_initialize(id, message["params"] || %{}) do
          {:ok, %{result: %{tools: tools}} = response} when is_list(tools) ->
            names = tools |> Enum.map(& &1.name) |> Enum.join(", ")
            client = get_in(message["params"] || %{}, ["clientInfo", "name"])
            who = if is_binary(client) and client != "", do: " (#{client})", else: ""
            Logger.info("[Corex MCP] connected#{who} — tools: #{names}")
            {:ok, response}

          other ->
            other
        end

      "tools/list" ->
        mcp_debug("Corex MCP tools/list")
        handle_list_tools(id, message["params"])

      "tools/call" ->
        mcp_debug(
          "Corex MCP tools/call params=#{inspect(message["params"], limit: 80, printable_limit: 200)}"
        )

        safe_call_tool(id, message["params"], assigns)

      "prompts/list" ->
        mcp_debug("Corex MCP prompts/list")
        handle_list_prompts(id, message["params"])

      "resources/list" ->
        mcp_debug("Corex MCP resources/list")
        handle_list_resources(id, message["params"])

      "resources/templates/list" ->
        mcp_debug("Corex MCP resources/templates/list")
        handle_list_templates(id, message["params"])

      other ->
        Logger.warning("Received unsupported method: #{other}")

        {:error,
         %{
           jsonrpc: "2.0",
           id: id,
           error: %{
             code: -32601,
             message: "Method not found",
             data: %{
               name: other
             }
           }
         }}
    end
  end

  defp validate_jsonrpc_message(%{"jsonrpc" => "2.0"} = message) do
    cond do
      Map.has_key?(message, "id") and Map.has_key?(message, "method") ->
        case message["id"] do
          id when is_binary(id) or is_number(id) -> {:ok, message}
          _ -> {:error, :invalid_jsonrpc}
        end

      not Map.has_key?(message, "id") and Map.has_key?(message, "method") ->
        {:ok, message}

      Map.has_key?(message, "id") and Map.has_key?(message, "result") ->
        {:ok, message}

      true ->
        {:error, :invalid_jsonrpc}
    end
  end

  defp validate_jsonrpc_message(_), do: {:error, :invalid_jsonrpc}

  defp send_json(conn, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status || 200, Corex.Json.encode!(data))
  end

  defp send_jsonrpc_error(conn, id, code, message, data \\ nil) do
    error = %{
      code: code,
      message: message
    }

    error = if data, do: Map.put(error, :data, data), else: error

    response = %{
      jsonrpc: "2.0",
      id: id,
      error: error
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Corex.Json.encode!(response))
  end

  @doc false
  def handle_http_message(conn) do
    :ok = init_tools()
    params = conn.body_params
    conn = fetch_query_params(conn)
    mcp_debug("Corex MCP POST body_keys=#{inspect(Map.keys(params))}")

    case validate_jsonrpc_message(params) do
      {:ok, message} ->
        assigns = Map.get(conn.private, :corex_mcp_config)

        case handle_message(message, assigns) do
          {:ok, nil} ->
            conn |> put_status(202) |> send_json(%{status: "ok"})

          {:ok, response} ->
            mcp_debug(
              "Corex MCP response id=#{inspect(response[:id])} keys=#{inspect(Map.keys(response))}"
            )

            conn |> put_status(200) |> send_json(response)

          {:error, error_response} ->
            Logger.warning("Error handling message: #{inspect(error_response)}")
            conn |> put_status(400) |> send_json(error_response)
        end

      {:error, :invalid_jsonrpc} ->
        Logger.warning("Invalid JSON-RPC message format")
        send_jsonrpc_error(conn, nil, -32600, "Could not parse message")
    end
  end
end
