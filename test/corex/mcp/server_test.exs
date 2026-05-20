defmodule Corex.MCP.ServerTest do
  use ExUnit.Case, async: false

  @moduletag capture_log: true

  alias Corex.MCP.Server

  setup do
    unless Application.get_env(:corex, :debug) do
      Logger.put_module_level(Corex.MCP.Server, :none)
    end

    :ok
  end

  defp post_conn(body_map) do
    Plug.Test.conn(:post, "/")
    |> Map.put(:body_params, body_map)
    |> Map.put(:params, body_map)
    |> Plug.Conn.put_private(:corex_mcp_config, %{allow_remote_access: false})
  end

  test "init_tools stores tools in :corex_mcp_tools" do
    assert :ok = Server.init_tools()
    assert {tools, _dispatch} = Server.tools_and_dispatch()
    assert tools != []
    names = Enum.map(tools, & &1.name)
    assert "list_components" in names
    assert "get_component" in names
    assert "installation_guide" in names
  end

  test "handle_http_message initialize returns protocol and tools" do
    body = %{
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "initialize",
      "params" => %{"protocolVersion" => "2025-03-26"}
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["result"]["protocolVersion"] == "2025-03-26"
    assert decoded["result"]["serverInfo"]["name"] == "Corex MCP"
    assert is_list(decoded["result"]["tools"])
  end

  test "handle_http_message rejects stale protocol version" do
    body = %{
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "initialize",
      "params" => %{"protocolVersion" => "2020-01-01"}
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 400
    assert conn.resp_body =~ "Unsupported protocol version"
  end

  test "handle_http_message ping" do
    body = %{"jsonrpc" => "2.0", "id" => 2, "method" => "ping"}

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["result"] == %{}
  end

  test "handle_http_message notifications/initialized returns 202" do
    body = %{"jsonrpc" => "2.0", "method" => "notifications/initialized"}

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 202
    assert Corex.Json.decode!(conn.resp_body) == %{"status" => "ok"}
  end

  test "handle_http_message invalid jsonrpc shape returns parse error" do
    body = %{"jsonrpc" => "2.0", "id" => 1}

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["error"]["code"] == -32_600
  end

  test "handle_http_message lists prompts and resources" do
    for {method, key} <- [{"prompts/list", "prompts"}, {"resources/list", "resources"}] do
      body = %{"jsonrpc" => "2.0", "id" => 3, "method" => method, "params" => %{}}

      conn =
        body
        |> post_conn()
        |> Server.handle_http_message()

      assert conn.status == 200
      decoded = Corex.Json.decode!(conn.resp_body)
      assert decoded["result"][key] == []
    end
  end

  test "handle_http_message unknown method returns JSON-RPC error" do
    body = %{"jsonrpc" => "2.0", "id" => 4, "method" => "custom/unknown", "params" => %{}}

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 400
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["error"]["code"] == -32_601
  end

  test "handle_http_message tools/call lists components" do
    body = %{
      "jsonrpc" => "2.0",
      "id" => 5,
      "method" => "tools/call",
      "params" => %{"name" => "list_components", "arguments" => %{}}
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    inner = decoded["result"]["content"] |> List.first()
    payload = Corex.Json.decode!(inner["text"])
    assert "accordion" in payload["components"]
  end

  test "handle_http_message tools/list" do
    body = %{"jsonrpc" => "2.0", "id" => 10, "method" => "tools/list", "params" => %{}}

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    assert is_list(decoded["result"]["tools"])
    assert Enum.any?(decoded["result"]["tools"], &(&1["name"] == "list_components"))
  end

  test "handle_http_message resources/templates/list" do
    body = %{
      "jsonrpc" => "2.0",
      "id" => 11,
      "method" => "resources/templates/list",
      "params" => %{}
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["result"]["templates"] == []
  end

  test "handle_http_message notifications/cancelled returns 202" do
    body = %{
      "jsonrpc" => "2.0",
      "method" => "notifications/cancelled",
      "params" => %{"requestId" => 1}
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 202
  end

  test "handle_http_message initialize without protocol version" do
    body = %{"jsonrpc" => "2.0", "id" => 12, "method" => "initialize", "params" => %{}}

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 400
    assert conn.resp_body =~ "Protocol version is required"
  end

  test "handle_http_message tools/call get_component invalid arguments" do
    body = %{
      "jsonrpc" => "2.0",
      "id" => 13,
      "method" => "tools/call",
      "params" => %{"name" => "get_component", "arguments" => %{}}
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 400
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["error"]["code"] == -32_602
  end

  test "handle_http_message tools/call unknown component returns tool error content" do
    body = %{
      "jsonrpc" => "2.0",
      "id" => 14,
      "method" => "tools/call",
      "params" => %{
        "name" => "get_component",
        "arguments" => %{"id" => "not_a_real_component_zzz"}
      }
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    inner = decoded["result"]["content"] |> List.first()
    assert inner["type"] == "text"
    assert inner["text"] =~ "Unknown component id"
    assert decoded["result"]["isError"] == true
  end

  test "handle_http_message invalid request id" do
    body = %{"jsonrpc" => "2.0", "id" => nil, "method" => "ping"}

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 200
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["error"]["code"] == -32_600
  end

  test "handle_http_message tools/call unknown tool returns method not found" do
    body = %{
      "jsonrpc" => "2.0",
      "id" => 6,
      "method" => "tools/call",
      "params" => %{"name" => "no_such_tool", "arguments" => %{}}
    }

    conn =
      body
      |> post_conn()
      |> Server.handle_http_message()

    assert conn.status == 400
    decoded = Corex.Json.decode!(conn.resp_body)
    assert decoded["error"]["code"] == -32_601
  end
end
