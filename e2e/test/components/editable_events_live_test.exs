defmodule E2eWeb.EditableEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "editable_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/editable/events", on_error: :warn)

    html =
      render_click(view, "editable_changed", %{
        "id" => "editable-events-server",
        "value" => "Hello"
      })

    assert html =~ ~S(data-part="row")
  end
end
