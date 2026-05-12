defmodule E2eWeb.ToggleGroupEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "toggle_group_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/toggle-group/events", on_error: :warn)

    html =
      render_click(view, "toggle_group_changed", %{
        "id" => "toggle-group-events-server",
        "value" => ["lorem", "duis"]
      })

    assert html =~ ~s(data-part="row")
  end
end
