defmodule E2eWeb.MarqueeEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "pause_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/marquee/events", on_error: :warn)

    html =
      render_click(view, "pause_changed", %{
        "id" => "marquee-events-server",
        "paused" => true
      })

    assert html =~ ~S(data-part="row")
  end
end
