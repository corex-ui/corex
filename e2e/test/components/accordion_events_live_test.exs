defmodule E2eWeb.AccordionEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "accordion_value_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/accordion/events")

    html =
      render_click(view, "accordion_value_changed", %{
        "id" => "events-on-value-change-server",
        "value" => ["duis"]
      })

    assert html =~ ~S(data-part="row")
  end

  test "accordion_client_changed inserts a client log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/accordion/events")

    html =
      render_click(view, "accordion_client_changed", %{
        "id" => "events-on-value-change-client",
        "value" => ["duis"]
      })

    assert html =~ ~S(data-part="row")
  end
end
