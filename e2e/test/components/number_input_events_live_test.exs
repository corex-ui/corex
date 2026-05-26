defmodule E2eWeb.NumberInputEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "number_input_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/events", on_error: :warn)

    html =
      render_click(view, "number_input_changed", %{
        "id" => "number-input-events-server",
        "value" => 3
      })

    assert html =~ ~S(data-part="row")
  end
end
