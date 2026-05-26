defmodule E2eWeb.SelectEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "select_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/events", on_error: :warn)

    html =
      render_click(view, "select_changed", %{
        "id" => "select-events-server",
        "value" => "fra"
      })

    assert html =~ ~S(data-part="row")
  end
end
