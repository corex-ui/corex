defmodule E2eWeb.ClipboardEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "clipboard_copied inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/clipboard/events", on_error: :warn)

    html =
      render_click(view, "clipboard_copied", %{
        "id" => "clipboard-events",
        "value" => "info@netoum.com"
      })

    assert html =~ ~S(data-part="row")
  end
end
