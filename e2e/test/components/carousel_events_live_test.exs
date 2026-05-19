defmodule E2eWeb.CarouselEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "carousel_page_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/carousel/events", on_error: :warn)

    html =
      render_click(view, "carousel_page_changed", %{
        "id" => "carousel-events-server",
        "page" => 1
      })

    assert html =~ ~S(data-part="row")
  end
end
