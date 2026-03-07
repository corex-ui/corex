defmodule E2eWeb.ErrorHTMLTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.Template, only: [render_to_string: 4]

  test "renders 404.html" do
    html = render_to_string(E2eWeb.ErrorHTML, "404", "html", [])
    assert html =~ "404"
    assert html =~ "Page Not Found"
    assert html =~ "does not exist"
  end

  test "returns 404 for nonexistent route", %{conn: conn} do
    conn = get(conn, "/en/nonexistent")
    assert conn.status == 404
    assert html_response(conn, 404) =~ "404"
    assert html_response(conn, 404) =~ "does not exist"
  end

  test "renders 500.html" do
    assert render_to_string(E2eWeb.ErrorHTML, "500", "html", []) ==
             "Internal Server Error"
  end
end
