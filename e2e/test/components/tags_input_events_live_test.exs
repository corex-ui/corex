defmodule E2eWeb.TagsInputEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "tags_value_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tags-input/events", on_error: :warn)

    html =
      render_click(view, "tags_value_changed", %{
        "id" => "tags-input-on-value-change-server",
        "value" => ["alpha"]
      })

    assert html =~ ~S(data-part="row")
  end
end
