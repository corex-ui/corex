defmodule E2eWeb.TooltipEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "tooltip_open_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/tooltip/events", on_error: :warn)

    html =
      render_click(view, "tooltip_open_changed", %{
        "id" => "tooltip-events",
        "open" => true
      })

    assert html =~ ~s(data-part="row")
  end
end
