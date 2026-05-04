defmodule E2eWeb.SwitchEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "server switch_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/switch/events")

    html =
      render_click(view, "switch_changed", %{
        "id" => "switch-on-checked-change-server",
        "checked" => true
      })

    assert html =~ ~s(data-part="row")
  end
end
