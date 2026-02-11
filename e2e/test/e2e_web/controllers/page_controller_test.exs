defmodule E2eWeb.PageControllerTest do
  use E2eWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn, 302) == ~p"/en"

    conn = get(conn, ~p"/en")
    assert html_response(conn, 200) =~ "Corex E2E tests"
  end
end
