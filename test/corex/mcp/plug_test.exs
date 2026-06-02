defmodule Corex.MCPTest do
  use ExUnit.Case, async: false

  alias Corex.MCP.{Config, Server}

  @moduletag capture_log: true

  describe "init/1" do
    test "defaults allow_remote_access to false" do
      assert %Config{allow_remote_access: false} = Corex.MCP.init([])
    end

    test "honours allow_remote_access" do
      assert %Config{allow_remote_access: true} = Corex.MCP.init(allow_remote_access: true)
    end

    test "logs a warning when allow_remote_access is true" do
      log =
        ExUnit.CaptureLog.capture_log(fn ->
          assert %{allow_remote_access: true} = Corex.MCP.init(allow_remote_access: true)
        end)

      assert log =~ "allow_remote_access is enabled"
    end

    test "defaults verbose_errors from application env" do
      assert %{verbose_errors: false} = Corex.MCP.init([])
    end

    test "accepts already-normalized map opts" do
      first = Corex.MCP.init([])
      assert first == Corex.MCP.init(first)
    end

    test "initializes MCP tools for dispatch" do
      Corex.MCP.init([])
      assert {tools, _dispatch} = Server.tools_and_dispatch()
      assert tools != []
    end
  end

  describe "call/2 non-corex paths" do
    test "does not rewrite CSP or remove x-frame-options" do
      opts = Corex.MCP.init([])
      csp = "default-src 'self'; script-src 'self' https://cdn.example; frame-ancestors 'none'"

      conn =
        Plug.Test.conn(:get, "/app")
        |> Corex.MCP.call(opts)
        |> Plug.Conn.put_resp_header("content-security-policy", csp)
        |> Plug.Conn.put_resp_header("x-frame-options", "DENY")
        |> Plug.Conn.send_resp(200, "ok")

      assert Plug.Conn.get_resp_header(conn, "content-security-policy") == [csp]
      assert Plug.Conn.get_resp_header(conn, "x-frame-options") == ["DENY"]
    end

    test "passes through non-corex requests without validating body params" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/app")
        |> Map.put(:body_params, %{})
        |> Corex.MCP.call(opts)

      refute conn.halted
    end
  end

  describe "call/2 /corex prefix" do
    test "serves MCP landing HTML on GET /corex/ from loopback" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/corex/")
        |> Map.put(:remote_ip, {127, 0, 0, 1})
        |> Corex.MCP.call(opts)

      assert conn.status == 200
      assert conn.halted
      assert conn.resp_body =~ "Corex MCP"
      assert conn.resp_body =~ "/corex/mcp"
    end

    test "raises when corex route runs after body was parsed" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/corex/mcp")
        |> Map.put(:remote_ip, {127, 0, 0, 1})
        |> Map.put(:body_params, %{})

      assert_raise RuntimeError, ~r/plug Corex.MCP is running too late/, fn ->
        Corex.MCP.call(conn, opts)
      end
    end

    test "403 for non-loopback remote ip when remote access disabled" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/corex/")
        |> Map.put(:remote_ip, {8, 8, 8, 8})
        |> Corex.MCP.call(opts)

      assert conn.status == 403
      assert conn.resp_body =~ "does not accept remote connections"
    end

    test "allows non-loopback when allow_remote_access is true" do
      opts = Corex.MCP.init(allow_remote_access: true)

      conn =
        Plug.Test.conn(:get, "/corex/")
        |> Map.put(:remote_ip, {8, 8, 8, 8})
        |> Corex.MCP.call(opts)

      assert conn.status == 200
    end

    test "GET /corex/config returns JSON from loopback" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/corex/config")
        |> Map.put(:remote_ip, {127, 0, 0, 1})
        |> Corex.MCP.call(opts)

      assert conn.status == 200
      decoded = Corex.Json.decode!(conn.resp_body)
      assert decoded["name"] == "corex"
      assert decoded["framework_type"] == "phoenix"
      refute Map.has_key?(decoded, "allow_remote_access")
      assert is_binary(decoded["corex_version"])
    end

    test "403 when Origin header is present on a nested route" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/corex/config")
        |> Map.put(:remote_ip, {127, 0, 0, 1})
        |> Plug.Conn.put_req_header("origin", "http://example.com")
        |> Corex.MCP.call(opts)

      assert conn.status == 403
      assert conn.resp_body =~ "origin header"
    end

    test "GET /corex/mcp is not allowed" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/corex/mcp")
        |> Map.put(:remote_ip, {127, 0, 0, 1})
        |> Corex.MCP.call(opts)

      assert conn.status == 405
      assert conn.resp_body == "Method Not Allowed"
    end

    test "POST /corex/mcp handles JSON-RPC ping" do
      opts = Corex.MCP.init([])

      body = Corex.Json.encode!(%{"jsonrpc" => "2.0", "id" => 1, "method" => "ping"})

      conn =
        Plug.Test.conn(:post, "/corex/mcp", body)
        |> Map.put(:remote_ip, {127, 0, 0, 1})
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> Corex.MCP.call(opts)

      assert conn.status == 200
      decoded = Corex.Json.decode!(conn.resp_body)
      assert decoded["result"] == %{}
    end

    test "unknown path returns 404" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/corex/no-such-endpoint")
        |> Map.put(:remote_ip, {127, 0, 0, 1})
        |> Corex.MCP.call(opts)

      assert conn.status == 404
    end
  end
end
