defmodule E2eWeb.DialogEventsLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "dialog_open_changed inserts log row in table", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/dialog/events", on_error: :warn)

    html =
      render_click(view, "dialog_open_changed", %{
        "id" => "dialog-events",
        "open" => true
      })

    assert html =~ "open_changed"
    assert html =~ ~s(data-part="row")
  end

  test "dialog_open_client_changed inserts log row in table", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/dialog/events", on_error: :warn)

    html =
      render_click(view, "dialog_open_client_changed", %{
        "id" => "dialog-events",
        "open" => false
      })

    assert html =~ "open_client_changed"
    assert html =~ ~s(data-part="row")
  end
end
