defmodule E2eWeb.DatePickerEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "dpe_on_value_server inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/date-picker/events")

    html =
      render_click(view, "dpe_on_value_server", %{
        "id" => "date-picker-e-sv",
        "value" => "2026-05-12"
      })

    assert html =~ ~s(data-part="row")
  end
end
