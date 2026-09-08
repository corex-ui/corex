defmodule E2eWeb.ToggleEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "toggle_pressed_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/toggle/events")

    html =
      render_click(view, "toggle_pressed_changed", %{
        "pressed" => "true"
      })

    assert html =~ ~S(data-part="row")
  end

  test "toggle_client_changed inserts a client log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/toggle/events")

    html =
      render_click(view, "toggle_client_changed", %{
        "id" => "toggle-on-pressed-change-client",
        "pressed" => "true"
      })

    assert html =~ ~S(data-part="row")
  end
end
