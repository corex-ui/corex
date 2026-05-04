defmodule E2eWeb.PageControllerTest do
  use E2eWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Phoenix"
    assert html_response(conn, 200) =~ "Corex"
  end

  test "GET /en", %{conn: conn} do
    conn = get(conn, "/en")
    assert html_response(conn, 200) =~ "Corex"
  end
end
