defmodule E2eWeb.MenuEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "menu_bind_open inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/menu/events")

    html =
      render_click(view, "menu_bind_open", %{
        "id" => "menu-events-bind",
        "open" => true
      })

    assert html =~ ~s(data-part="row")
  end
end
