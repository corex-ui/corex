defmodule E2eWeb.CheckboxEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "checkbox_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/checkbox/events")

    html =
      render_click(view, "checkbox_changed", %{
        "id" => "checkbox-on-checked-change-server",
        "checked" => true
      })

    assert html =~ ~s(data-part="row")
  end
end
