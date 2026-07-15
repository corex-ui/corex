defmodule E2eWeb.CorexMcpTest do
  use E2eWeb.ConnCase, async: true

  @mcp_path "/corex/mcp"
  @base_path "/corex"
  @config_path "/corex/config"

  describe "GET routes" do
    test "GET /corex serves landing HTML", %{conn: conn} do
      conn = get(conn, @base_path)
      assert response(conn, 200) =~ "Corex Model Context Protocol"
    end

    test "GET /corex/config returns JSON", %{conn: conn} do
      conn = get(conn, @config_path)
      assert response(conn, 200)
      assert %{"name" => "corex", "framework_type" => "phoenix"} = json_response(conn, 200)
    end
  end

  describe "POST /corex/mcp" do
    test "tools/list returns corex tools", %{conn: conn} do
      body = %{
        "jsonrpc" => "2.0",
        "id" => 1,
        "method" => "tools/list",
        "params" => %{}
      }

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(@mcp_path, Jason.encode!(body))

      assert response(conn, 200)
      assert %{"result" => %{"tools" => tools}} = json_response(conn, 200)
      names = Enum.map(tools, & &1["name"])
      assert "list_components" in names
      assert "get_component" in names
      assert "list_modifiers" in names
      assert "get_component_style" in names
      assert "list_themes" in names
      assert "design_guide" in names
      assert "installation_guide" in names

      for tool <- tools do
        assert %{"annotations" => %{"readOnlyHint" => true}} = tool
      end
    end

    test "prompts/list, resources/list, resources/templates/list return empty",
         %{
           conn: conn
         } do
      for {method, key} <- [
            {"prompts/list", "prompts"},
            {"resources/list", "resources"},
            {"resources/templates/list", "templates"}
          ] do
        body = %{
          "jsonrpc" => "2.0",
          "id" => 1,
          "method" => method,
          "params" => %{}
        }

        conn =
          conn
          |> put_req_header("content-type", "application/json")
          |> post(@mcp_path, Jason.encode!(body))

        assert response(conn, 200)
        assert %{"result" => result} = json_response(conn, 200)
        assert result[key] == []
      end
    end

    test "tools/call list_components", %{conn: conn} do
      body = %{
        "jsonrpc" => "2.0",
        "id" => 2,
        "method" => "tools/call",
        "params" => %{
          "name" => "list_components",
          "arguments" => %{}
        }
      }

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(@mcp_path, Jason.encode!(body))

      assert response(conn, 200)
      assert %{"result" => %{"content" => [%{"text" => text}]}} = json_response(conn, 200)
      assert text =~ "accordion"
      assert text =~ "combobox"
    end

    test "tools/call get_component for accordion includes docs", %{conn: conn} do
      body = %{
        "jsonrpc" => "2.0",
        "id" => 3,
        "method" => "tools/call",
        "params" => %{
          "name" => "get_component",
          "arguments" => %{"id" => "accordion"}
        }
      }

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(@mcp_path, Jason.encode!(body))

      assert response(conn, 200)
      assert %{"result" => %{"content" => [%{"text" => text}]}} = json_response(conn, 200)
      assert text =~ "Corex.Accordion"
      assert text =~ "accordion"
      decoded = Jason.decode!(text)
      assert is_binary(decoded["docs"])
      assert decoded["docs"] != ""
      assert is_list(decoded["attrs"])
      assert decoded["design_available"] == true
      assert decoded["css_id"] == "accordion"
    end

    test "tools/call list_modifiers", %{conn: conn} do
      body = %{
        "jsonrpc" => "2.0",
        "id" => 4,
        "method" => "tools/call",
        "params" => %{
          "name" => "list_modifiers",
          "arguments" => %{}
        }
      }

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(@mcp_path, Jason.encode!(body))

      assert response(conn, 200)
      assert %{"result" => %{"content" => [%{"text" => text}]}} = json_response(conn, 200)
      decoded = Jason.decode!(text)
      assert decoded["pattern"] =~ "ui-"
      assert "accent" in decoded["semantic"]["roles"]
    end

    test "tools/call get_component_style for accordion", %{conn: conn} do
      body = %{
        "jsonrpc" => "2.0",
        "id" => 5,
        "method" => "tools/call",
        "params" => %{
          "name" => "get_component_style",
          "arguments" => %{"id" => "accordion"}
        }
      }

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(@mcp_path, Jason.encode!(body))

      assert response(conn, 200)
      assert %{"result" => %{"content" => [%{"text" => text}]}} = json_response(conn, 200)
      decoded = Jason.decode!(text)
      assert decoded["css_id"] == "accordion"
      assert is_list(decoded["examples"])
    end

    test "rejects request with Origin header", %{
      conn: conn
    } do
      body = %{
        "jsonrpc" => "2.0",
        "id" => 1,
        "method" => "tools/list",
        "params" => %{}
      }

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("origin", "http://example.com")
        |> post(@mcp_path, Jason.encode!(body))

      assert response(conn, 403)
    end
  end
end
