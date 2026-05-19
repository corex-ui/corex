defmodule E2eWeb.TooltipEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "tooltip_open_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tooltip/events", on_error: :warn)

    html =
      render_click(view, "tooltip_open_changed", %{
        "id" => "tooltip-events",
        "open" => true
      })

    assert html =~ ~S(data-part="row")
  end
end
