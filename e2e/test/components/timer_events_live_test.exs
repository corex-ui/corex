defmodule E2eWeb.TimerEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "timer_tick inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/timer/events", on_error: :warn)

    html =
      render_click(view, "timer_tick", %{
        "id" => "timer-events-server",
        "formattedTime" => "01:00:00"
      })

    assert html =~ ~s(data-part="row")
  end
end
