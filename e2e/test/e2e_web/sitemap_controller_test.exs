defmodule E2eWeb.SitemapControllerTest do
  use E2eWeb.ConnCase, async: true

  test "GET /sitemap.xml", %{conn: conn} do
    conn = get(conn, "/sitemap.xml")
    body = response(conn, 200)

    assert body =~ ~S(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">)
    assert body =~ "<loc>"
    assert body =~ "/blog"
    assert body =~ "/blog/anatomy-of-a-corex-component"
  end
end
