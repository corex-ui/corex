defmodule E2eWeb.LiveDocRouteSmokeTest do
  use E2eWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  @live_routes Enum.filter(E2eWeb.DocA11yRoutes.all(), fn {path, _} ->
                 match?(
                   %{plug: Phoenix.LiveView.Plug},
                   Phoenix.Router.route_info(E2eWeb.Router, "GET", path, "")
                 )
               end)

  test "every DocA11yRoutes LiveView mounts with its root id", %{conn: conn} do
    for {path, root_sel} <- @live_routes do
      {:ok, _view, html} = live(conn, path, on_error: :warn)
      id = String.trim_leading(root_sel, "#")
      assert html =~ ~s(id="#{id}"), "missing root id #{id} on #{path}"
    end
  end
end
