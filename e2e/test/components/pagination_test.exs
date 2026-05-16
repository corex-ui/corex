defmodule E2eWeb.PaginationTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "anatomy page includes pagination", %{conn: conn} do
    conn = get(conn, ~p"/pagination/anatomy")
    html = html_response(conn, 200)
    assert html =~ ~s(data-scope="pagination")
    assert html =~ ~s(data-part="prev-trigger")
    assert html =~ ~s(data-part="next-trigger")
  end

  test "events live logs page change", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/pagination/events")

    html =
      render_click(view, "pagination_page_changed", %{
        "id" => "pagination-events-server",
        "page" => 2,
        "page_size" => 10
      })

    assert html =~ "pagination-events-server"
    assert html =~ "2"
  end

  test "patterns live controlled page", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/pagination/patterns", on_error: :warn)

    html =
      render_click(view, "pagination_controlled_changed", %{
        "id" => "pagination-patterns-controlled",
        "page" => 3,
        "page_size" => 4
      })

    assert html =~ "Current page: 3"
  end

  test "patterns live server page updates posts", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/pagination/patterns", on_error: :warn)

    html =
      render_click(view, "patterns_server_page", %{
        "id" => "pagination-patterns-server",
        "page" => 2,
        "page_size" => 4
      })

    assert html =~ "Zag.js under the hood"
  end

  test "patterns live link patch includes phx-link", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/pagination/patterns", on_error: :warn)

    assert html =~ ~s(data-phx-link="patch")
    assert html =~ "pagination-patterns-patch"
  end

  test "patterns live patch params load page slice", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/pagination/patterns?page=2", on_error: :warn)

    assert html =~ "Zag.js under the hood"
  end

  test "patterns link patch data tab includes blog module and demo url", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/pagination/patterns", on_error: :warn)

    assert html =~ "MyApp.Blog"
    assert html =~ "pagination/patterns?page=1&amp;page_size=4"
  end
end
