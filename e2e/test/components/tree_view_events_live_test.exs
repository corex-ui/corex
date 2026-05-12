defmodule E2eWeb.TreeViewEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "tree_server_expanded inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/tree-view/events")

    html =
      render_click(view, "tree_server_expanded", %{
        "id" => "tree-events-server",
        "expandedValue" => ["repo-corex"]
      })

    assert html =~ ~s(data-part="row")
  end
end
