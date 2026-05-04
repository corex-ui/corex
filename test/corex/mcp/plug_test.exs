defmodule Corex.MCPTest do
  use ExUnit.Case, async: true

  @moduletag capture_log: true

  describe "init/1" do
    test "defaults allow_remote_access to false" do
      assert %{allow_remote_access: false} = Corex.MCP.init([])
    end

    test "honours allow_remote_access" do
      assert %{allow_remote_access: true} = Corex.MCP.init(allow_remote_access: true)
    end

    test "accepts already-normalized map opts" do
      first = Corex.MCP.init([])
      assert first == Corex.MCP.init(first)
    end
  end

  describe "call/2 non-corex paths" do
    test "rewrites script-src for unsafe-eval and strips frame-ancestors from CSP" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/app")
        |> Corex.MCP.call(opts)
        |> Plug.Conn.put_resp_header(
          "content-security-policy",
          "default-src 'self'; script-src 'self' https://cdn.example; frame-ancestors 'none'"
        )
        |> Plug.Conn.put_resp_header("x-frame-options", "DENY")
        |> Plug.Conn.send_resp(200, "ok")

      [csp] = Plug.Conn.get_resp_header(conn, "content-security-policy")
      assert csp =~ "script-src"
      assert csp =~ "'unsafe-eval'"
      refute csp =~ "frame-ancestors"
      assert Plug.Conn.get_resp_header(conn, "x-frame-options") == []
    end

    test "leaves CSP unchanged when header absent" do
      opts = Corex.MCP.init([])

      conn =
        Plug.Test.conn(:get, "/")
        |> Corex.MCP.call(opts)
        |> Plug.Conn.send_resp(204, "")

      assert Plug.Conn.get_resp_header(conn, "content-security-policy") == []
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

      assert_raise RuntimeError, ~r/plug Corex.MCP is runnning too late/, fn ->
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
      assert decoded["allow_remote_access"] == false
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
