defmodule E2eWeb.DialogEventsLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "dialog_open_changed inserts log row in table", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/dialog/events", on_error: :warn)

    html =
      render_click(view, "dialog_open_changed", %{
        "id" => "dialog-events-server",
        "open" => true
      })

    assert html =~ "server"
    assert html =~ ~S(data-part="row")
  end

  test "dialog_open_client_changed inserts log row in table", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/dialog/events", on_error: :warn)

    html =
      render_click(view, "dialog_open_client_changed", %{
        "id" => "dialog-events-client",
        "open" => false
      })

    assert html =~ "client"
    assert html =~ ~S(data-part="row")
  end
end
