defmodule E2eWeb.TimerEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "timer_tick inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/timer/events", on_error: :warn)

    html =
      render_click(view, "timer_tick", %{
        "id" => "timer-events-server",
        "formattedTime" => %{
          "days" => "00",
          "hours" => "01",
          "minutes" => "00",
          "seconds" => "00",
          "milliseconds" => "000"
        }
      })

    assert html =~ ~s(data-part="row")
    assert html =~ "01:00:00"
  end
end
