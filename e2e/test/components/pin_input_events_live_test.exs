defmodule E2eWeb.PinInputEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "pin_input_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/pin-input/events", on_error: :warn)

    html =
      render_click(view, "pin_input_changed", %{
        "id" => "pin-input-events-server",
        "value" => "1234"
      })

    assert html =~ ~s(data-part="row")
  end
end
