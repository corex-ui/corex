defmodule E2eWeb.CarouselEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "carousel_page_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/carousel/events", on_error: :warn)

    html =
      render_click(view, "carousel_page_changed", %{
        "id" => "carousel-events-server",
        "page" => 1,
        "pageSnapPoint" => 448
      })

    assert html =~ ~S(data-part="row")
    assert html =~ "448"
  end

  test "carousel_page_client_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/carousel/events", on_error: :warn)

    html =
      render_click(view, "carousel_page_client_changed", %{
        "id" => "carousel-events-client",
        "page" => 2,
        "pageSnapPoint" => 896
      })

    assert html =~ ~S(data-part="row")
    assert html =~ "2"
    assert html =~ "896"
  end
end
