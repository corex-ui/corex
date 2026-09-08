defmodule E2eWeb.ActionEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "noop event keeps the patterns page", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/action/patterns")
    html = render_click(view, "noop", %{})
    assert html =~ "action" or html =~ "Pattern"
  end
end
