defmodule E2eWeb.SliderEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "slider_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/events")

    html =
      render_click(view, "slider_changed", %{
        "id" => "events-slider-on-value-change-server",
        "value" => [45.0]
      })

    assert html =~ ~S(data-part="row")
  end
end
