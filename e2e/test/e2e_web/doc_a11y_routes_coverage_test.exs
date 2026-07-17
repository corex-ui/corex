defmodule E2eWeb.DocA11yRoutesCoverageTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @moduletag :doc_smoke

  @live_paths MapSet.new(
                for {path, _} <- E2eWeb.DocA11yRoutes.all(),
                    match?(
                      %{plug: Phoenix.LiveView.Plug},
                      Phoenix.Router.route_info(E2eWeb.Router, "GET", path, "")
                    ),
                    do: path
              )

  for {path, root_sel} <- E2eWeb.DocA11yRoutes.all() do
    @path path
    @root_id String.trim_leading(root_sel, "#")
    @is_live MapSet.member?(@live_paths, path)

    test "router resolves #{path}" do
      assert match?(%{}, Phoenix.Router.route_info(E2eWeb.Router, "GET", @path, "")),
             "missing route for #{@path}"
    end

    test "GET #{path} returns 200 with root id", %{conn: conn} do
      conn = get(conn, @path)
      assert conn.status == 200, "expected 200 for #{@path}, got #{inspect(conn.status)}"
      assert html_response(conn, 200) =~ ~s(id="#{@root_id}")
    end

    if @is_live do
      test "LiveView #{path} mounts with root id", %{conn: conn} do
        assert {_view, html} = live_ok!(conn, @path, on_error: :warn)
        assert html =~ ~s(id="#{@root_id}")
      end
    end
  end
end
