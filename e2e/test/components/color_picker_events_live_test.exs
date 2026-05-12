defmodule E2eWeb.ColorPickerEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "cp_ev_server_value inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/color-picker/events")

    html =
      render_click(view, "cp_ev_server_value", %{
        "id" => "color-picker-ev-sv",
        "valueAsString" => "#ff0000"
      })

    assert html =~ ~s(data-part="row")
  end
end
