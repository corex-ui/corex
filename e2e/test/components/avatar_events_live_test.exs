defmodule E2eWeb.AvatarEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "avatar_status_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/avatar/events")

    html =
      render_click(view, "avatar_status_changed", %{
        "id" => "avatar-events",
        "status" => "loaded"
      })

    assert html =~ ~s(data-part="row")
  end
end
