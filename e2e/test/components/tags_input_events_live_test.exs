defmodule E2eWeb.TagsInputEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "tags_value_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/tags-input/events", on_error: :warn)

    html =
      render_click(view, "tags_value_changed", %{
        "id" => "tags-input-on-value-change-server",
        "value" => ["alpha"]
      })

    assert html =~ ~s(data-part="row")
  end
end
