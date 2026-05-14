defmodule E2eWeb.DocA11yRoutesCoverageTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "every doc path resolves on the router", %{conn: _conn} do
    for {path, _} <- E2eWeb.DocA11yRoutes.all() do
      assert match?(%{}, Phoenix.Router.route_info(E2eWeb.Router, "GET", path, "")),
             "missing route for #{path}"
    end
  end

  test "every doc path returns 200 and exposes its root id", %{conn: conn} do
    for {path, root_sel} <- E2eWeb.DocA11yRoutes.all() do
      conn = get(conn, path)
      assert conn.status == 200, "expected 200 for #{path}, got #{conn.status}"
      id = String.trim_leading(root_sel, "#")
      assert html_response(conn, 200) =~ ~s(id="#{id}")
    end
  end

  test "every doc LiveView path mounts with stable root id", %{conn: conn} do
    for {path, root_sel} <- E2eWeb.DocA11yRoutes.all() do
      case Phoenix.Router.route_info(E2eWeb.Router, "GET", path, "") do
        %{plug: Phoenix.LiveView.Plug} ->
          assert {:ok, _view, html} = live(conn, path, on_error: :warn)
          id = String.trim_leading(root_sel, "#")
          assert html =~ ~s(id="#{id}")

        _ ->
          :ok
      end
    end
  end
end
