defmodule E2eWeb.ComboboxEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "combobox_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/combobox/events")

    html =
      render_click(view, "combobox_changed", %{
        "id" => "combobox-events-server-field",
        "value" => "fra"
      })

    assert html =~ ~s(data-part="row")
  end
end
