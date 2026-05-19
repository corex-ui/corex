defmodule E2eWeb.AngleSliderEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "angle_slider_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/angle-slider/events")

    html =
      render_click(view, "angle_slider_changed", %{
        "id" => "events-angle-slider-on-value-change-server",
        "value" => 45.0
      })

    assert html =~ ~S(data-part="row")
  end
end
