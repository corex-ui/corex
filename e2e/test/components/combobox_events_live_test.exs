defmodule E2eWeb.ComboboxEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "combobox_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/combobox/events")

    html =
      render_click(view, "combobox_changed", %{
        "id" => "combobox-events-server-field",
        "value" => "fra"
      })

    assert html =~ ~S(data-part="row")
  end
end
