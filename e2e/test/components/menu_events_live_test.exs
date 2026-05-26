defmodule E2eWeb.MenuEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "menu_bind_open inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/menu/events")

    html =
      render_click(view, "menu_bind_open", %{
        "id" => "menu-events-bind",
        "open" => true
      })

    assert html =~ ~S(data-part="row")
  end
end
