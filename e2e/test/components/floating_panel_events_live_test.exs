defmodule E2eWeb.FloatingPanelEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "floating_panel_open_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/floating-panel/events")

    html =
      render_click(view, "floating_panel_open_changed", %{
        "id" => "fp-events-live",
        "open" => true
      })

    assert html =~ ~S(data-part="row")
  end
end
