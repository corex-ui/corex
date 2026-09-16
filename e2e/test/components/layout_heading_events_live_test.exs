defmodule E2eWeb.LayoutHeadingEventsLiveTest do
  use E2eWeb.ConnCase

  test "anatomy page renders layout heading examples", %{conn: conn} do
    conn = get(conn, ~p"/layout-heading/anatomy")
    assert html_response(conn, 200) =~ "layout-heading"
  end
end
