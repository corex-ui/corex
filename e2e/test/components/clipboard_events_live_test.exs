defmodule E2eWeb.ClipboardEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "clipboard_copied inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/clipboard/events", on_error: :warn)

    html =
      render_click(view, "clipboard_copied", %{
        "id" => "clipboard-events",
        "value" => "info@netoum.com"
      })

    assert html =~ ~s(data-part="row")
  end
end
