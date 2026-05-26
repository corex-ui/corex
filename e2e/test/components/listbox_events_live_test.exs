defmodule E2eWeb.ListboxEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "listbox_value_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/listbox/events", on_error: :warn)

    html =
      render_click(view, "listbox_value_changed", %{
        "id" => "listbox-events-server",
        "value" => "fra"
      })

    assert html =~ ~S(data-part="row")
  end
end
