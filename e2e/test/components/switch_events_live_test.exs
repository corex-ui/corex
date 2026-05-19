defmodule E2eWeb.SwitchEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "server switch_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/events")

    html =
      render_click(view, "switch_changed", %{
        "id" => "switch-on-checked-change-server",
        "checked" => true
      })

    assert html =~ ~S(data-part="row")
  end
end
