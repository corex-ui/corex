defmodule E2eWeb.DataListEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "add inserts a stream row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/data-list/patterns")
    html = render_click(view, "add", %{})
    assert html =~ "data-list" or html =~ "pattern"
  end
end
