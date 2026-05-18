defmodule E2eWeb.PaginationEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "pagination_page_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/pagination/events", on_error: :warn)

    html =
      render_click(view, "pagination_page_changed", %{
        "id" => "pagination-events-server",
        "page" => "2"
      })

    assert html =~ ~s(data-part="row")
  end
end
