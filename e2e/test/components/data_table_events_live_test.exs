defmodule E2eWeb.DataTableEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "pattern_stream_add keeps the patterns page", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/data-table/patterns")

    html = render_click(view, "pattern_stream_add", %{})
    assert html =~ "data-table" or html =~ "pattern"
  end

  test "row_click records the selected row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/data-table/patterns")

    html = render_click(view, "row_click", %{"id" => "1", "name" => "Alice"})
    assert html =~ "Alice"
  end
end
