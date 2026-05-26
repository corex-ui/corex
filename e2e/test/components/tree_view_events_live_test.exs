defmodule E2eWeb.TreeViewEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "tree_server_expanded inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tree-view/events")

    html =
      render_click(view, "tree_server_expanded", %{
        "id" => "tree-events-server",
        "expandedValue" => ["repo-corex"]
      })

    assert html =~ ~S(data-part="row")
  end
end
