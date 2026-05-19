defmodule E2eWeb.RadioGroupEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "radio_group_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/radio-group/events", on_error: :warn)

    html =
      render_click(view, "radio_group_changed", %{
        "id" => "radio-group-events-server",
        "value" => "b"
      })

    assert html =~ ~S(data-part="row")
  end
end
