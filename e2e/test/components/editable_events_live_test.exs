defmodule E2eWeb.EditableEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "editable_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/editable/events", on_error: :warn)

    html =
      render_click(view, "editable_changed", %{
        "id" => "editable-events-server",
        "value" => "Hello"
      })

    assert html =~ ~s(data-part="row")
  end
end
