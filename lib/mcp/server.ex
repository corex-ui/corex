# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit
# See LICENSE for third-party notices.
# Modifications: Corex.MCP namespace; ETS :corex_mcp_tools; Corex.MCP.Tools.*; Corex
#   serverInfo; init_tools (re)loads tool specs from raw_tools/0 on each call so metadata
#   (e.g. readOnlyHint) and callbacks stay in sync with the current build.

defmodule Corex.MCP.Server do
  @moduledoc false
  require Logger
  import Plug.Conn

  alias Corex.MCP.Tools.Components, as: McpToolComponents
  alias Corex.MCP.Tools.Installation, as: McpToolInstallation

  @protocol_version "2025-03-26"
  @vsn Mix.Project.config()[:version] || "0.0.0"

  defp raw_tools do
    tools =
      [McpToolComponents.tools(), McpToolInstallation.tools()]
      |> List.flatten()

    if Mix.env() == :test do
      tools ++ [test_raise_tool()]
    else
      tools
    end
  end

  defp test_raise_tool do
    %{
      name: "test_raise",
      description: "Test-only tool that raises",
      inputSchema: %{
        type: "object",
        properties: %{}
      },
      callback: fn _args, _assigns -> raise "secret internal path" end
    }
  end

  @doc "Loads tool specs and callbacks into `:corex_mcp_tools` ETS."
  def init_tools do
    tools = raw_tools()
    dispatch_map = Map.new(tools, fn tool -> {tool.name, tool.callback} end)

    if :ets.whereis(:corex_mcp_tools) == :undefined do
      :ets.new(:corex_mcp_tools, [
        :set,
        :named_table,
        :public,
        read_concurrency: true
      ])
    end

    :ets.insert(:corex_mcp_tools, {:tools, {tools, dispatch_map}})
    :ok
  end

  @doc "Returns the stored `{tools, dispatch}` tuple from ETS."
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
           code: -32_601,
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
    params = params || %{}

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
       error: %{code: -32_602, message: "Invalid arguments for tool"}
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
      stacktrace = __STACKTRACE__
      formatted = Exception.format(kind, reason, stacktrace)

      unless verbose_errors?(assigns) do
        Logger.error("Corex.MCP tool call failed: #{formatted}")
      end

      text =
        if verbose_errors?(assigns) do
          "Failed to call tool: #{formatted}"
        else
          "Failed to call tool"
        end

      {:ok,
       %{
         jsonrpc: "2.0",
         id: request_id,
         result: %{
           content: [
             %{
               type: "text",
               text: text
             }
           ],
           isError: true
         }
       }}
  end

  defp verbose_errors?(assigns) when is_map(assigns) do
    Map.get(assigns, :verbose_errors, Application.get_env(:corex, :mcp_verbose_errors, false))
  end

  defp verbose_errors?(_), do: Application.get_env(:corex, :mcp_verbose_errors, false)

  defp handle_message(%{"method" => "notifications/initialized"} = message, _assigns) do
    mcp_debug("Received initialized notification")
    mcp_debug("Full message: #{inspect(message, pretty: true)}")
    {:ok, nil}
  end

  defp handle_message(%{"method" => "notifications/cancelled"} = message, _assigns) do
    mcp_debug("Request cancelled: #{inspect(message["params"])}")
    {:ok, nil}
  end

  defp handle_message(%{"method" => method, "id" => id} = message, assigns) do
    mcp_debug("Routing MCP message - Method: #{method}, ID: #{id}")
    mcp_debug("Full message: #{inspect(message, pretty: true)}")
    route_mcp_method(method, id, message, assigns)
  end

  defp route_mcp_method("ping", id, _message, _assigns) do
    Logger.debug("Handling ping request")
    handle_ping(id)
  end

  defp route_mcp_method("initialize", id, message, _assigns) do
    mcp_debug(
      "Handling initialize request with params: #{inspect(message["params"], pretty: true)}"
    )

    handle_initialize(id, message["params"])
  end

  defp route_mcp_method("tools/list", id, message, _assigns) do
    Logger.debug("Handling tools list request")
    handle_list_tools(id, message["params"])
  end

  defp route_mcp_method("tools/call", id, message, assigns) do
    mcp_debug(
      "Handling tool call request with params: #{inspect(message["params"], pretty: true)}"
    )

    safe_call_tool(id, message["params"], assigns)
  end

  defp route_mcp_method("prompts/list", id, message, _assigns) do
    Logger.debug("Handling prompts list request")
    handle_list_prompts(id, message["params"])
  end

  defp route_mcp_method("resources/list", id, message, _assigns) do
    Logger.debug("Handling resources list request")
    handle_list_resources(id, message["params"])
  end

  defp route_mcp_method("resources/templates/list", id, message, _assigns) do
    Logger.debug("Handling templates list request")
    handle_list_templates(id, message["params"])
  end

  defp route_mcp_method(other, id, _message, _assigns) do
    Logger.warning("Received unsupported method: #{other}")

    {:error,
     %{
       jsonrpc: "2.0",
       id: id,
       error: %{
         code: -32_601,
         message: "Method not found",
         data: %{name: other}
       }
     }}
  end

  defp validate_jsonrpc_message(%{"jsonrpc" => "2.0"} = message) do
    case {Map.has_key?(message, "id"), Map.has_key?(message, "method"),
          Map.has_key?(message, "result")} do
      {true, true, _} ->
        validate_jsonrpc_request_id(message["id"], message)

      {false, true, _} ->
        {:ok, message}

      {true, _, true} ->
        {:ok, message}

      _ ->
        {:error, :invalid_jsonrpc}
    end
  end

  defp validate_jsonrpc_message(_), do: {:error, :invalid_jsonrpc}

  defp validate_jsonrpc_request_id(id, message) when is_binary(id) or is_number(id),
    do: {:ok, message}

  defp validate_jsonrpc_request_id(_, _), do: {:error, :invalid_jsonrpc}

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

  @doc "Handles a JSON-RPC MCP request over HTTP."
  def handle_http_message(conn) do
    :ok = init_tools()
    mcp_debug("Received #{conn.method} message")
    params = conn.body_params
    conn = fetch_query_params(conn)
    mcp_debug("Raw params: #{inspect(params, pretty: true)}")

    case validate_jsonrpc_message(params) do
      {:ok, message} ->
        assigns = conn.private.corex_mcp_config

        case handle_message(message, assigns) do
          {:ok, nil} ->
            conn |> put_status(202) |> send_json(%{status: "ok"})

          {:ok, response} ->
            mcp_debug("Sending HTTP response: #{inspect(response, pretty: true)}")
            conn |> put_status(200) |> send_json(response)

          {:error, error_response} ->
            Logger.warning("Error handling MCP message: #{inspect(error_response)}")
            conn |> put_status(400) |> send_json(error_response)
        end

      {:error, :invalid_jsonrpc} ->
        Logger.warning("Invalid JSON-RPC message format")
        send_jsonrpc_error(conn, nil, -32_600, "Could not parse message")
    end
  end

  defp mcp_debug(message) do
    if Application.get_env(:corex, :debug) do
      Logger.debug(message)
    end
  end
end
