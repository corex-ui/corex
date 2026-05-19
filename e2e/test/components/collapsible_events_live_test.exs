defmodule E2eWeb.CollapsibleEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "collapsible_open_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/collapsible/events", on_error: :warn)

    html =
      render_click(view, "collapsible_open_changed", %{
        "id" => "collapsible-events-server",
        "open" => true
      })

    assert html =~ ~S(data-part="row")
  end
end
