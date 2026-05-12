defmodule E2eWeb.TabsEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "tabs_value_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/tabs/events", on_error: :warn)

    html =
      render_click(view, "tabs_value_changed", %{
        "id" => "tabs-events-server",
        "value" => "duis"
      })

    assert html =~ ~s(data-part="row")
  end
end
