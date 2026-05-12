defmodule E2eWeb.CollapsibleEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "collapsible_open_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/collapsible/events", on_error: :warn)

    html =
      render_click(view, "collapsible_open_changed", %{
        "id" => "collapsible-events-server",
        "open" => true
      })

    assert html =~ ~s(data-part="row")
  end
end
